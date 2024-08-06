//
//  UIApplication+Extensions.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit

extension UIApplication {
    static func topViewController() -> UIViewController? {
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootViewController = window.rootViewController {
            return rootViewController.topMostViewController()
        }
        return nil
    }
}

extension UIViewController {
    @objc func topMostViewController() -> UIViewController? {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        } else {
            for view in self.view.subviews {
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        if let viewController = subViewController as? UIViewController {
                            return viewController.topMostViewController()
                        }
                    }
                }
            }
            return self
        }
    }
}
