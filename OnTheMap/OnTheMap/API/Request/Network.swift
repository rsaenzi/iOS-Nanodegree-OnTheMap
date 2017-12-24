//
//  Network.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias NetworkCompletion = (_ result: NetworkResult) -> ()

class Network {
    static let shared = Network()
    
    func request(_ endpoint: ApiEndpoint, _ completion: @escaping NetworkCompletion) {
        
        print("Request to: \(endpoint.url)")
        let task = URLSession.shared.dataTask(with: endpoint.request) { data, response, error in
            
            // Detect any request error
            guard error == nil, let data = data else {
                completion(.errorRequest)
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

enum NetworkResult {
    case success(jsonString: String)
    
    case errorRequest
    case errorDataDecoding
}
