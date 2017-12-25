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
    
    static func post(username: String, password: String, completion: @escaping GetSessionIdCompletion) {
        
        let endpoint = ApiEndpoint.getSessionId(username: username, password: password)
        Request.shared.request(endpoint) { result in
            
            switch result {
            case .success(let jsonString, let statusCode):
                
                // We need to delete the first 5 characters, according to Udacity API documentation
                let cleanJsonString = String(jsonString.dropFirst(5))
                
                guard let udacitySession = decode(from: cleanJsonString) else {
                    call(completion, returning: .errorJsonDecoding)
                    return
                }
                
                call(completion, returning: .success(session: udacitySession))
                
            case .errorRequest:
                call(completion, returning: .errorRequest)
                
            case .errorDataDecoding:
                call(completion, returning: .errorDataDecoding)
                
            case .errorInvalidStatusCode(let statusCode):
                
                // This status code represent invalid credentials
                if statusCode == 403 {
                    call(completion, returning: .invalidCredentials)
                    return
                }
                
                call(completion, returning: .errorInvalidStatusCode)
                
            case .errorNoStatusCode:
                call(completion, returning: .errorNoStatusCode)
            }
        }
    }
    
    private static func call(_ completion: @escaping GetSessionIdCompletion, returning result: GetSessionIdResult) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

// MARK: JSON Decoding
extension GetSessionIdRequest {
    
    private static func decode(from jsonString: String) -> UdacitySession? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormats.server.formatter)
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        var object: UdacitySession?
        do {
            object = try decoder.decode(UdacitySession.self, from: jsonData)
        } catch {
            print(error)
            return nil
        }
        
        return object
    }
}

// MARK: Result
enum GetSessionIdResult {
    case success(session: UdacitySession)
    
    case invalidCredentials
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}

