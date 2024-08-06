//
//  DashboardViewController.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var tblCategory: UITableView!
    
    private var dashboardViewModel = DashboardViewModel()
    private var router = AppRouter()
    
    override func viewWillAppear(_ animated: Bool) {
        self.dashboardViewModel.handleEvent(event: .fetchData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.addViewModelListeners()
        // Do any additional setup after loading the view.
    }
}

//MARK: Private Methods
extension DashboardViewController {
    private func configUI() {
        if let navigationController {
            navigationController.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        self.tblCategory.dataSource = dashboardViewModel
        self.tblCategory.delegate = dashboardViewModel
        self.tblCategory.register(UINib(nibName: CategoryHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryHeaderTableViewCell.identifier)
        self.tblCategory.register(UINib(nibName: InspectionStatusTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: InspectionStatusTableViewCell.identifier)
        
        self.dashboardViewModel.handleEvent(event: .fetchData)
    }
    
    //MARK: Model Listeners
    private func addViewModelListeners() {
        self.dashboardViewModel.UpdateUI = {[weak self] title in
            if let this = self {
                DispatchQueue.main.async {
                    this.tblCategory.reloadData()
                    this.title = title
                }
            }
        }
        
        self.dashboardViewModel.routeToScreen = {[weak self] route, parameter in
            if let this = self {
                DispatchQueue.main.async {
                    this.router.route(to: route, from: this, parameters: parameter)
                }
            }
        }
        
        self.dashboardViewModel.showAlert = { message in
            Utility.showAlert(title: "Assignment Demo", message: message, buttons: [.okButton]) { (_) in
            }
        }
    }
}
