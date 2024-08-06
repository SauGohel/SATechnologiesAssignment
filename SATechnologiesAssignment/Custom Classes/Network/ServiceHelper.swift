//
//  ServiceHelper.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 04/08/24.
//

import Foundation

// MARK: All Apis
class ServiceHelper {
    
    private static let baseURl: String = "http://127.0.0.1:5001/api/"
    
    static func getLoginUrl() -> String {
        return self.baseURl + "login"
    }
    
    static func getRegisterUrl() -> String {
        return self.baseURl + "register"
    }
    
    static func getInspectionStartUrl() -> String {
        return self.baseURl + "inspections/start"
    }
    
    static func getSubmitUrl() -> String {
        return self.baseURl + "inspections/submit"
    }
    
}


import Foundation

class NetworkManager {
    
    // Static shared instance
    static let shared = NetworkManager()
    
    // Private initializer to prevent instantiation
    private init() {}
    
    // Example GET request method
    func getRequest(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
    
    // Example POST request method
    func postRequest(urlString: String, parameters: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
