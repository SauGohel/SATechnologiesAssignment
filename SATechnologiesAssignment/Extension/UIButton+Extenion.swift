//
//  UIButton+Extenions.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 03/08/24.
//

import UIKit

extension UIButton {
    func applyNavyBlue(title: String, cornerRadius: CGFloat) {
        DispatchQueue.main.async {
            self.backgroundColor = .AppNavyBluePrimaryColor
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = false
            self.setTitleColor(.AppWhiteColor, for: .normal)
            self.titleLabel?.font = .boldSystemFont(ofSize: 15)
            self.setTitle(title, for: .normal)
            self.titleLabel?.textColor = .AppWhiteColor
            self.isUserInteractionEnabled = true
        }
    }

    func applyWhiteButton(title: String, cornerRadius: CGFloat) {
        DispatchQueue.main.async {
            self.backgroundColor = .AppWhiteColor
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = false
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.AppNavyBluePrimaryColor.cgColor
            self.setTitleColor(.AppNavyBluePrimaryColor, for: .normal)
            self.titleLabel?.font = .boldSystemFont(ofSize: 15)
            self.setTitle(title, for: .normal)
            self.titleLabel?.textColor = .AppNavyBluePrimaryColor
            self.isUserInteractionEnabled = true
        }
    }
}
