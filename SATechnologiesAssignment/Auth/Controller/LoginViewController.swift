//
//  LoginViewController.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    private var loginViewModel = LoginViewModel()
    private var router = AppRouter()
    
    override func viewWillAppear(_ animated: Bool) {
        if CoreDataManager.shared.isInspectionDataPresent() {
            self.router.route(to: .dashboard, from: self, parameters: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.addViewModelListeners()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Action Buttons
    @IBAction func btnSubmitAction(_ sender: Any) {
        self.loginViewModel.handleEvent(event: .submit(email: txtEmail.text, password: txtPassword.text))
    }
    
    @IBAction func btnRegisterAction(_ sender: Any) {
        self.loginViewModel.handleEvent(event: .register)
    }
}

//MARK: Private Methods
extension LoginViewController {
    
    private func configUI() {
        self.txtEmail.text = "asd@asd.asd"
        self.txtPassword.text = "123"
        self.txtEmail.placeholder = "Email"
        self.txtEmail.setPadding(left: 10, right: 10)
        
        self.txtPassword.placeholder = "Password"
        self.txtPassword.setPadding(left: 10, right: 10)
        self.txtPassword.isSecureTextEntry = true
        
        self.btnLogin.applyNavyBlue(title: "Login", cornerRadius: 10)
        self.btnRegister.applyWhiteButton(title: "Register", cornerRadius: 10)
    }
    
    //MARK: Model Listeners
    private func addViewModelListeners() {
        self.loginViewModel.routeToScreen = {[weak self] route, parameter in
            if let this = self {
                DispatchQueue.main.async {
                    this.router.route(to: route, from: this, parameters: parameter)
                }
            }
        }
        
        self.loginViewModel.showAlert = { message in
            DispatchQueue.main.async {
                Utility.showAlert(title: "Assignment Demo", message: message, buttons: [.okButton]) { (_) in
                }
            }
        }
    }
}
