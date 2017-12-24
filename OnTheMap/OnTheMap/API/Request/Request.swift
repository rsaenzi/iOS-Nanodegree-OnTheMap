//
//  Request.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias RequestCompletion = (_ result: RequestResult) -> ()

class Request {
    static let shared = Request()
    
    func request(_ endpoint: ApiEndpoint, successStatusCode: Int = 200, _ completion: @escaping RequestCompletion) {
        
        print("Request to: \(endpoint.url)")
        let task = URLSession.shared.dataTask(with: endpoint.request) { data, response, error in
            
            // Detect any request error
            guard error == nil, let data = data else {
                completion(.errorRequest)
                return
            }
            
            // Fetch status code from response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.errorNoStatusCode)
                return
            }
            
            // Status code must be valid
            print("Status Code:\(httpResponse.statusCode)")
            guard httpResponse.statusCode == successStatusCode else {
                completion(.errorInvalidStatusCode)
                return
            }
            
            // Transforms raw data into string
            guard let jsonString = String(data: data, encoding: .utf8) else {
                completion(.errorDataDecoding)
                return
            }
            
            // Return the json string
            print("Response:\n\(jsonString)")
            completion(.success(jsonString: jsonString))
        }
        task.resume()
    }
}

enum RequestResult {
    case success(jsonString: String)
    
    case errorRequest
    case errorNoStatusCode
    case errorInvalidStatusCode
    case errorDataDecoding
}
