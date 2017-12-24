//
//  GetSessionIdRequest.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias GetSessionIdCompletion = (_ result: GetSessionIdResult) -> ()

// MARK: Request
class GetSessionIdRequest {
    
    static let shared = GetSessionIdRequest()
    
    func get(username: String, password: String, completion: @escaping GetSessionIdCompletion) {
        
        let endpoint = ApiEndpoint.getSessionId(username: username, password: password)
        Request.shared.request(endpoint) { result in
            
            switch result {
            case .success(let jsonString):
                
                // We need to delete the first 5 characters, according to Udacity API documentation
                let cleanJsonString = String(jsonString.dropFirst(5))
                
                guard let udacitySession = self.decode(from: cleanJsonString) else {
                    completion(.errorJsonDecoding)
                    return
                }
                
                completion(.success(session: udacitySession))
                
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
extension GetSessionIdRequest {
    
    private func decode(from jsonString: String) -> UdacitySession? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormats.server.formatter)
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        guard let object = try? decoder.decode(UdacitySession.self, from: jsonData) else {
            return nil
        }
        
        return object
    }
}

// MARK: Result
enum GetSessionIdResult {
    case success(session: UdacitySession)
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}

