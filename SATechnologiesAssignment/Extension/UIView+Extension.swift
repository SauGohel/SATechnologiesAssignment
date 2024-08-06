//
//  UIView+Extension.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 05/08/24.
//

import UIKit

extension UIView {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
