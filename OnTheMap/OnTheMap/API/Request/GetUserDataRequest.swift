//
//  GetUserDataRequest.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias GetUserDataCompletion = (_ result: GetUserDataResult) -> ()

// MARK: Request
class GetUserDataRequest {
    
    static func get(userId: String, completion: @escaping GetUserDataCompletion) {
        
        let endpoint = ApiEndpoint.getUserData(userId: userId)
        Request.shared.request(endpoint) { result in
            
            switch result {
            case .success(let jsonString):
                
                // We need to delete the first 5 characters, according to Udacity API documentation
                let cleanJsonString = String(jsonString.dropFirst(5))
                
                guard let userData = decode(from: cleanJsonString) else {
                    completion(.errorJsonDecoding)
                    return
                }
                
                completion(.success(userData: userData))
                
            case .errorRequest:
                completion(.errorRequest)
                
            case .errorDataDecoding:
                completion(.errorDataDecoding)
                
            case .errorInvalidStatusCode:
                completion(.errorInvalidStatusCode)
                
            case .errorNoStatusCode:
                completion(.errorNoStatusCode)
            }
        }
    }
}

// MARK: JSON Decoding
extension GetUserDataRequest {
    
    private static func decode(from jsonString: String) -> UdacityUserData? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormats.server.formatter)
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        guard let object = try? decoder.decode(UdacityUserData.self, from: jsonData) else {
            return nil
        }
        
        return object
    }
}

// MARK: Result
enum GetUserDataResult {
    case success(userData: UdacityUserData)
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}


