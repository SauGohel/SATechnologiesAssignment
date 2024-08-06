//
//  QAndAViewController.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import UIKit

class QAndAViewController: UIViewController {
    
    @IBOutlet weak var tblQandAns: UITableView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    private var qAndAViewModel = QAndAViewModel()
    private var router = AppRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.addViewModelListeners()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        qAndAViewModel.handleEvent(event: .next)
    }
    
    @IBAction func btnPreviousAction(_ sender: Any) {
        qAndAViewModel.handleEvent(event: .previous)
    }
    
    func getViewModel() -> QAndAViewModel? {
        return qAndAViewModel
    }
    
}


extension QAndAViewController {
    
    private func configUI() {
        
        if let navigationController {
            navigationController.isNavigationBarHidden = false
        }
        
        self.tblQandAns.register(UINib(nibName: CategoryHeaderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryHeaderTableViewCell.identifier)
        
        self.tblQandAns.register(UINib(nibName: OptionsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OptionsTableViewCell.identifier)
        
        self.tblQandAns.dataSource = qAndAViewModel
        self.tblQandAns.delegate = qAndAViewModel
        
        self.title = "MCQ"
        
        self.btnNext.applyNavyBlue(title: "Next", cornerRadius: 5)
        self.btnPrevious.applyNavyBlue(title: "Previous", cornerRadius: 5)
        DispatchQueue.main.async {
            self.qAndAViewModel.handleEvent(event: .fetchData)
        }
    }
    
    private func addViewModelListeners() {
        
        self.qAndAViewModel.reloadData = {[weak self] in
            if let this = self {
                DispatchQueue.main.async {
                    this.tblQandAns.reloadData()
                    this.btnPrevious.isHidden = this.qAndAViewModel.getQuestionCount().questionNumber == 0 ? true : false
                    this.qAndAViewModel.getQuestionCount().questionNumber == this.qAndAViewModel.getQuestionCount().questionCount - 1 ? this.btnNext.applyNavyBlue(title: "Submit", cornerRadius: 5) :
                    this.btnNext.applyNavyBlue(title: "Next", cornerRadius: 5)
                }
            }
        }
        
        self.qAndAViewModel.routeToScreen = {[weak self] route, parameter in
            if let this = self {
                DispatchQueue.main.async {
                    this.router.route(to: route, from: this, parameters: parameter)
                }
            }
        }
        
        self.qAndAViewModel.showAlert = {[weak self] message, isDataSubmitted in
            if let this = self {
                DispatchQueue.main.async {
                    Utility.showAlert(title: "Assignment Demo", message: message, buttons: [.okButton]) { (_) in
                        if isDataSubmitted {
                            this.router.route(to: .dashboard, from: this, parameters: nil)
                        }
                    }
                }
            }
        }
    }
}
