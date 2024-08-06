//
//  CommonResponseModel.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 04/08/24.
//

import Foundation

struct CommonResponseModel: Codable {
    
    let message: String?
    let error: String?
    
    init(message: String?, error: String?) {
        self.message = message
        self.error = error
    }
}
    
