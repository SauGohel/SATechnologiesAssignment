//
//  Services.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 04/08/24.
//

import Foundation

struct Service {
    var url: String!
    var httpMethod: WebserviceHTTPMethod
    var params: [String: Any]
    
    init(httpMethod: WebserviceHTTPMethod) {
        self.httpMethod = httpMethod
        self.params = [String: Any]()
    }
}

enum WebserviceHTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

