//
//  LoginViewModel.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit

class LoginViewModel: NSObject {
    enum LoginEvent {
        case submit(email: String?, password: String?)
        case register
        case none
    }
    
    var routeToScreen: ((_ router: Route, _ parameters: Any?) -> Void)?
    var showAlert: ((_ message: String) -> Void)?
}

//MARK: Public Methods
extension LoginViewModel {
    
    func handleEvent(event: LoginEvent) {
        switch event {
        case .submit(email: let email, password: let password):
            self.checkCredentials(email: email, password: password)
        case .register:
            if let closure = self.routeToScreen {
                closure(.register, nil)
            }
        default: break
        }
    }
}

//MARK: Private Methods
extension LoginViewModel {
    private func checkCredentials(email: String?, password: String?) {
        if !(email ?? "").isEmpty && !(password ?? "").isEmpty {
            if (email ?? "").isValidEmail {
                self.callLoginApi(email: email!, password: password!)
            } else {
                self.showAlertPopUp("Please Enter Valid Email Address")
            }
        } else {
            if (email ?? "").isEmpty || !(email ?? "").isValidEmail {
                self.showAlertPopUp("Please Enter Valid Email Address")
            } else {
                self.showAlertPopUp("Invalid Password")
            }
        }
    }
    
    private func callLoginApi(email: String, password: String) {
        
        var service = Service.init(httpMethod: .POST)
        service.url = ServiceHelper.getLoginUrl()
        service.params = ["email": email,
                          "password": password]
        ServiceManager.shared.getRequest(service: service, model: CommonResponseModel.self) { (response, statusCode, error) in
            if let statusCode = statusCode, statusCode >= 200 && statusCode < 300 {
                if let closure = self.routeToScreen {
                    closure(.dashboard, nil)
                }
            } else {
                if let response {
                    self.showAlertPopUp(response.error ?? "")
                } else {
                    self.showAlertPopUp(error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    private func showAlertPopUp(_ message: String) {
        guard let showAlert else { return }
        showAlert(message)
    }
}
