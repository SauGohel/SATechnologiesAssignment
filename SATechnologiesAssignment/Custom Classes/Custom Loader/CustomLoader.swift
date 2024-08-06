//
//  CustomLoader.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit

class CustomLoader: UIView {
    
    var indicatorColor: UIColor
    var loadingViewColor: UIColor
    var loadingMessage: String
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    init(inview: UIView, loadingViewColor: UIColor, indicatorColor: UIColor, msg: String){
        self.indicatorColor = indicatorColor
        self.loadingViewColor = loadingViewColor
        self.loadingMessage = msg
        super.init(frame: CGRect(x: inview.bounds.midX - 90, y: inview.bounds.midY - 50, width: 180, height: 100))
        initalizeCustomIndicator()
    }
    
    convenience init(inview: UIView) {
        
        self.init(inview: inview, loadingViewColor: UIColor.lightGray, indicatorColor: UIColor.black, msg: "Loading..")
    }
    convenience init(inview: UIView, messsage: String) {
        
        self.init(inview: inview, loadingViewColor: UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0), indicatorColor: UIColor.black, msg: messsage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initalizeCustomIndicator() {
        messageFrame.frame = self.bounds
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.tintColor = indicatorColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: self.messageFrame.frame.midX - 15, y: 10, width: 30, height: 50)
        let strLabel = UILabel(frame: CGRect(x: 10, y: self.activityIndicator.frame.maxY, width: self.messageFrame.frame.width - 20, height: 30))
        strLabel.text = loadingMessage
        strLabel.adjustsFontSizeToFitWidth = true
        strLabel.textColor = UIColor.darkGray
        strLabel.textAlignment = .center
        strLabel.font = .boldSystemFont(ofSize: 15)
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = loadingViewColor
        messageFrame.alpha = 0.8
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)
    }
    
    func start() {
        // check if view is already there or not..if again started
        if !self.subviews.contains(messageFrame) {
            activityIndicator.startAnimating()
            self.superview?.isUserInteractionEnabled = false
            self.addSubview(messageFrame)
        }
    }
    
    func stop() {
        if self.subviews.contains(messageFrame) {
            activityIndicator.stopAnimating()
            self.superview?.isUserInteractionEnabled = true
            messageFrame.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}
