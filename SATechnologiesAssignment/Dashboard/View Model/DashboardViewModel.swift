//
//  DashboardViewModel.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import UIKit

class DashboardViewModel: NSObject {
    enum DashboardEvent {
        case fetchData
        case login
        case none
    }
    
    private var inspectionData: InspectionData?
    
    var UpdateUI: ((_ title: String) -> Void)?
    var routeToScreen: ((_ router: Route, _ parameters: Any?) -> Void)?
    var showAlert: ((_ message: String) -> Void)?
}

//MARK: API Methods
extension DashboardViewModel {
    private func callFetchInspectionApi() {
        var service = Service.init(httpMethod: .GET)
        service.url = ServiceHelper.getInspectionStartUrl()
        ServiceManager.shared.getRequest(service: service, model: InspectionResponseModel.self) { (response, statusCode, error) in
            if let statusCode = statusCode, statusCode >= 200 && statusCode < 300 {
                if let closure = self.UpdateUI, let response = response {
                    CoreDataManager.shared.storeInspectionResponseModel(response)
                    if let data = CoreDataManager.shared.fetchAllInspections() {
                        self.inspectionData = data
                        closure(data.inspectionType?.name ?? "")
                    }
                }
            } else {
                guard let showAlert = self.showAlert else { return }
                showAlert(error?.localizedDescription ?? "")
            }
        }
    }
}

//MARK: Public Methods
extension DashboardViewModel {
    func handleEvent(event: DashboardEvent) {
        switch event {
        case .fetchData:
            if  CoreDataManager.shared.isInspectionDataPresent() {
                if let data = CoreDataManager.shared.fetchAllInspections(), let  UpdateUI {
                    inspectionData = data
                    UpdateUI(data.inspectionType?.name ?? "")
                }
            } else {
                self.callFetchInspectionApi()
            }
        default: break
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension DashboardViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: CategoryHeaderTableViewCell.identifier) as? CategoryHeaderTableViewCell {
            headerCell.setupCellData(title: inspectionData?.area?.name ?? "")
            return headerCell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inspectionData?.survey?.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: InspectionStatusTableViewCell.identifier, for: indexPath) as? InspectionStatusTableViewCell {
            if let data = inspectionData?.survey, let categories = data.categories {
                cell.setupCategoryCellData(title: categories[indexPath.row].name ?? "", isSubmitted: categories[indexPath.row].isSubmitted, score: categories[indexPath.row].totalScore, isStarted: (categories[indexPath.row].questions!.filter{ $0.selectedAnswerChoiceId != 0 }.count) > 0 ? true : false)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let closure = routeToScreen, let data = inspectionData?.survey, let categories = data.categories?[indexPath.row] {
            if !(categories.isSubmitted ?? true) {
                closure(.mcq, categories)
            }
        }
    }
}
