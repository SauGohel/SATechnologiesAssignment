//
//  QAndAViewModel.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import UIKit
import CoreData

class QAndAViewModel: NSObject {
    enum QAndAEvent {
        case fetchData
        case next
        case previous
        case none
    }
    
    private var inspectionData: Category?
    private var questionNumber: Int = 0 {
        didSet {
            if let reloadData {
                reloadData()
            }
        }
    }
    private var isSelected: Int = -1 {
        didSet {
            if let reloadData {
                reloadData()
            }
        }
    }
    var updateUI: ((_ title: String) -> Void)?
    var reloadData: (() -> Void)?
    var routeToScreen: ((_ router: Route, _ parameters: Any?) -> Void)?
    var showAlert: ((_ message: String, _ isSubmitted: Bool) -> Void)?
}

//MARK: Public Methods
extension QAndAViewModel {
    func setInspectioData(dataObj: Category?) {
        if let dataObj{
            self.inspectionData = dataObj
        }
    }
    
    func getQuestionCount() -> (questionCount: Int, questionNumber: Int) {
        return (questionCount: inspectionData?.questions?.count ?? 0, questionNumber: questionNumber)
    }
    
    func handleEvent(event: QAndAEvent) {
        switch event {
        case .fetchData:
            if let reloadData {
                reloadData()
            }
        case .next:
            if (inspectionData?.questions?.count ?? 0) - 1 != questionNumber {
                questionNumber += 1
                isSelected = -1
            } else {
                callSubmitApi()
            }
        case .previous:
            questionNumber -= 1
        default: break
        }
    }
}

//MARK: Private Methods
extension QAndAViewModel {
    private func callSubmitApi() {
        var service = Service.init(httpMethod: .POST)
        service.url = ServiceHelper.getSubmitUrl()
        service.params = ["inspection": ["id": CoreDataManager.shared.fetchAllInspections()?.id]]
        ServiceManager.shared.getRequest(service: service, model: InspectionResponseModel.self) { (response, statusCode, error) in
            if let statusCode = statusCode, statusCode >= 200 && statusCode < 300 {
                self.updateCoreData()
            } else {
                guard let showAlert = self.showAlert else { return }
                showAlert(error?.localizedDescription ?? "", false)
            }
        }
    }
    
    private func updateCoreData() {
        let allQuestions = inspectionData.flatMap { $0.questions }
        let selectedScores = allQuestions?.compactMap { question in
            question.answerChoices?.first { $0.id == question.selectedAnswerChoiceId }?.score
        }
        let totalScore = selectedScores?.reduce(0.0, +)
        CoreDataManager.shared.updateCategoryScore(id: Int64(inspectionData?.id ?? 0), isSubmitted: true, score: totalScore ?? 0.0)
        
        if let closure = showAlert {
            closure("Your total score is \(totalScore ?? 0.0)", true)
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension QAndAViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: CategoryHeaderTableViewCell.identifier) as? CategoryHeaderTableViewCell {
            headerCell.setupCellData(title: inspectionData?.questions?[questionNumber].name ?? "")
            return headerCell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inspectionData?.questions?[questionNumber].answerChoices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.identifier, for: indexPath) as? OptionsTableViewCell {
            if let data = inspectionData?.questions?[questionNumber], let ansChoice = data.answerChoices {
                cell.setupOptionData(options: ansChoice[indexPath.row], isSelected: data.selectedAnswerChoiceId == ansChoice[indexPath.row].id ? true : false)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedId = self.inspectionData?.questions?[self.questionNumber].answerChoices?[indexPath.row].id {
            self.inspectionData?.questions?[self.questionNumber].selectedAnswerChoiceId = selectedId
            DispatchQueue.main.async {
                CoreDataManager.shared.updateQuestionModel(self.inspectionData?.questions?[self.questionNumber].id ?? -10, answerId: selectedId)
            }
        }
        self.isSelected = indexPath.row
    }
}

