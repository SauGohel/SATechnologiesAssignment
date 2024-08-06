//
//  RegisterViewController.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    private var registerViewModel = RegisterViewModel()
    private var router = AppRouter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.addViewModelListeners()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Action Buttons
    @IBAction func btnRegisterAction(_ sender: Any) {
        self.registerViewModel.handleEvent(event: .register(email: self.txtEmail.text, password: self.txtPassword.text, confirmPassword: self.txtConfirmPassword.text))
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        self.registerViewModel.handleEvent(event: .login)
    }
}


//MARK: Private Methods
extension RegisterViewController {
    
    private func configUI() {
        if let navigationController {
            navigationController.isNavigationBarHidden = true
        }
        self.txtEmail.placeholder = "Email"
        self.txtEmail.setPadding(left: 10, right: 10)
        
        self.txtPassword.placeholder = "Password"
        self.txtPassword.setPadding(left: 10, right: 10)
        self.txtPassword.isSecureTextEntry = true
        
        self.txtConfirmPassword.placeholder = "Confirm Password"
        self.txtConfirmPassword.setPadding(left: 10, right: 10)
        self.txtConfirmPassword.isSecureTextEntry = true
        
        self.btnLogin.applyWhiteButton(title: "Already have account? Login", cornerRadius: 10)
        self.btnRegister.applyNavyBlue(title: "Register", cornerRadius: 10)
    }
    
    //MARK: Model Listeners
    private func addViewModelListeners() {
        self.registerViewModel.popScreen = {[weak self] in
            if let this = self {
                DispatchQueue.main.async {
                    this.router.pop(from: this, animation: true)
                }
            }
        }
        
        self.registerViewModel.routeToScreen = {[weak self] route, parameter in
            if let this = self {
                DispatchQueue.main.async {
                    this.router.route(to: route, from: this, parameters: parameter)
                }
            }
        }
        
        self.registerViewModel.showAlert = {[weak self] message, isPop in
            if let this = self {
                DispatchQueue.main.async {
                    Utility.showAlert(title: "Assignment Demo", message: message, buttons: [.okButton]) { (_) in
                        if isPop {
                            this.router.pop(from: this, animation: true)
                        }
                    }
                }
            }
        }
    }
}
