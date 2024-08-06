//
//  ServiceManager.swift
//  SATechnologiesAssignment
//
//  Created by Saurabh Gohel on 04/08/24.
//

import UIKit

class ServiceManager: NSObject {
    
    //MARK: Static shared instance
    static let shared = ServiceManager()
    
    private override init() {}
    
    //MARK: Method to configure URL request
    private func configureRequest(service: Service) -> URLRequest? {
        guard let url = URL(string: service.url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = service.httpMethod.rawValue
        
        if !service.params.isEmpty {
            if service.httpMethod == .GET {
                var urlComponents = URLComponents(string: service.url)
                urlComponents?.queryItems = service.params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                request.url = urlComponents?.url
            } else {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: service.params, options: [])
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    print("Error in encoding parameters: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
        return request
    }
    
    //MARK: Generic GET/POST request method
    func getRequest<T: Codable>(service: Service, model: T.Type, isLoader: Bool = true, responseProcessingBlock: @escaping (T?, Int?, Error?) -> Void) {
        guard Utility.isNetworkAvailable() else {
                responseProcessingBlock(nil, nil, NSError(domain: "", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No Internet Connection"]))
                return
            }
            
            guard let request = configureRequest(service: service) else {
                responseProcessingBlock(nil, nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL or parameters"]))
                return
            }
            
            if isLoader {
                Utility.sharedInstance.showLoader()
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if isLoader {
                    Utility.sharedInstance.hideLoader()
                }
                
                if let error = error {
                    responseProcessingBlock(nil, nil, error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    responseProcessingBlock(nil, nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                    return
                }
                
                let statusCode = httpResponse.statusCode
                
                if statusCode >= 200 && statusCode < 300 {
                    if let data = data, !data.isEmpty {
                        do {
                            let decodedObject = try JSONDecoder().decode(T.self, from: data)
                            responseProcessingBlock(decodedObject, statusCode, nil)
                        } catch {
                            let decodingError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(error.localizedDescription)"])
                            responseProcessingBlock(nil, statusCode, decodingError)
                        }
                    } else {
                        responseProcessingBlock(nil, statusCode, nil)
                    }
                } else {
                    if let data = data, !data.isEmpty {
                        do {
                            let decodedError = try JSONDecoder().decode(T.self, from: data)
                            responseProcessingBlock(decodedError, statusCode, nil)
                        } catch {
                            let decodingError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(error.localizedDescription)"])
                            responseProcessingBlock(nil, statusCode, decodingError)
                        }
                    } else {
                        let responseError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: statusCode)])
                        responseProcessingBlock(nil, statusCode, responseError)
                    }
                }
            }
        task.resume()
    }
}

