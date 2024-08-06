//
//  Utility.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit
import SystemConfiguration

class Utility {
    
    static let sharedInstance = Utility()
    
    private var activityIndicator: CustomLoader?
    
    // MARK: - Loader Methods
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            if let this = self {
                if this.activityIndicator == nil {
                    if let shared = SceneDelegate.shared, let window = shared.window {
                        this.activityIndicator = CustomLoader(inview: window, messsage: "Loading...")
                        window.addSubview(this.activityIndicator!)
                        this.activityIndicator?.start()
                    }
                } else {
                    this.hideLoader()
                    this.showLoader()
                }
            }
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            if let this = self {
                if let indicator = this.activityIndicator {
                    indicator.stop()
                    this.activityIndicator = nil
                }
            }
        }
    }
    
    
    // MARK: - Network Methods
    static func isNetworkAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    // MARK: - Alert Methods
    static func showAlert(title: String, message: String, buttons: [AlertButtonType], handler: @escaping (AlertButtonType) -> Void) {
        DispatchQueue.main.async {
            if let topController = UIApplication.topViewController() {
                if topController is UIAlertController {
                } else {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    buttons.forEach { button in
                        alert.addAction(
                            UIAlertAction(title: button.rawValue, style: .default, handler: { action in
                                if let index = alert.actions.firstIndex(where: { $0 === action }) {
                                    handler(buttons[index])
                                }
                            })
                        )
                    }
                    topController.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}


enum AlertButtonType: String {
    case okButton = "OK"
    case okay = "Okay"
    case cancel = "CANCEL"
    case yes = "Yes"
}
