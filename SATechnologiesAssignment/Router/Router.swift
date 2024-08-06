//
//  Router.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit

enum AppStoryBoard: String {
    case auth = "Auth"
    case dash = "Dashboard"
    case none
}

enum Route: String {
    case login
    case register
    case dashboard
    case mcq
    case none
}

protocol Router {
    func route(
        to route: Route,
        from context: UIViewController,
        parameters: Any?
    )
    func pop(
        from context: UIViewController, animation: Bool
    )
}


class AppRouter: Router {
    func pop(from context: UIViewController, animation: Bool) {
        DispatchQueue.main.async {
            if let navcontroller = context.navigationController {
                navcontroller.popViewController(animated: animation)
            }
        }
    }
    
    func route (to route: Route, from context: UIViewController, parameters: Any?) {
        DispatchQueue.main.async {
            switch route {
                
            case .login:
                if let controller = self.getViewController(ofType: LoginViewController.self, storyBoard: AppStoryBoard.auth.rawValue) {
                    context.navigationController?.pushViewController(controller, animated: true)
                }
            case .register:
                if let controller = self.getViewController(ofType: RegisterViewController.self, storyBoard: AppStoryBoard.auth.rawValue) {
                    context.navigationController?.pushViewController(controller, animated: true)
                }
            case .dashboard:
                if let controller = self.getViewController(ofType: DashboardViewController.self, storyBoard: AppStoryBoard.dash.rawValue) {
                    context.navigationController?.pushViewController(controller, animated: false)
                }
            case .mcq:
                if let controller = self.getViewController(ofType: QAndAViewController.self, storyBoard: AppStoryBoard.dash.rawValue) {
                    if let viewModel = controller.getViewModel(), let data = parameters as? Category {
                        viewModel.setInspectioData(dataObj: data)
                    }
                    context.navigationController?.pushViewController(controller, animated: true)
                }
            default: break
            }
        }
    }
    
    // MARK: - Get ViewController From Storyboard
    private func getViewController<T: UIViewController>(ofType viewController: T.Type, storyBoard: String) -> T? {
        if let controller = UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: String(describing: type(of: T()))) as? T {
            return controller
        }
        return nil
    }
}
