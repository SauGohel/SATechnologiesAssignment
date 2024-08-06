//
//  RegisterViewModel.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import UIKit

class RegisterViewModel: NSObject {
    
    enum RegisterEvent {
        case register(email: String?, password: String?, confirmPassword: String?)
        case login
        case none
    }
    
    var popScreen: (() -> Void)?
    var routeToScreen: ((_ router: Route, _ parameters: Any?) -> Void)?
    var showAlert: ((_ message: String, _ isPop: Bool) -> Void)?
}

//MARK: Public Methods
extension RegisterViewModel {
    func handleEvent(event: RegisterEvent) {
        switch event {
        case .register(email: let email, password: let password, confirmPassword: let confirmPassword):
            checkCredentials(email: email, password: password, confirmPassword: confirmPassword)
        case .login:
            if let closure = self.popScreen {
                closure()
            }
        default: break
        }
    }
}

//MARK: Private Methods
extension RegisterViewModel {
    private func checkCredentials(email: String?, password: String?, confirmPassword: String?) {
        if !(email ?? "").isEmpty && !(password ?? "").isEmpty {
            if (email ?? "").isValidEmail && password == confirmPassword {
                self.callRegisterApi(email: email!, password: password!)
            } else {
                password == confirmPassword ?
                showAlertPopUp("Please Enter Valid Email Address") :
                showAlertPopUp("Please Enter Same Password")
            }
        } else {
            ((email ?? "").isEmpty || !(email ?? "").isValidEmail) ?
            showAlertPopUp("Please Enter Valid Email Address") :
            showAlertPopUp("Please Enter Same Password")
        }
    }
    
    private func callRegisterApi(email: String, password: String) {
        
        var service = Service.init(httpMethod: .POST)
        service.url = ServiceHelper.getRegisterUrl()
        service.params = ["email": email,
                          "password": password]
        ServiceManager.shared.getRequest(service: service, model: CommonResponseModel.self) { (response, statusCode, error) in
            if let statusCode = statusCode, statusCode >= 200 && statusCode < 300 {
                if let closure = self.showAlert {
                    closure("Registration Successful!", true)
                }
            } else {
                response != nil ?
                self.showAlertPopUp(response!.error ?? "") :
                self.showAlertPopUp(error?.localizedDescription ?? "")
            }
        }
    }
    
    private func showAlertPopUp(_ message: String) {
        guard let showAlert else { return }
        showAlert(message, false)
    }
}

