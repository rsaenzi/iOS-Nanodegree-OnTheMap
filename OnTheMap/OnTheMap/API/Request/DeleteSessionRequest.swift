//
//  DeleteSessionRequest.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias DeleteSessionCompletion = (_ result: DeleteSessionResult) -> ()

// MARK: Request
class DeleteSessionRequest {
    
    static func post(completion: @escaping DeleteSessionCompletion) {
        
        let endpoint = ApiEndpoint.deleteSession
        Request.shared.request(endpoint) { result in
            
            switch result {
            case .success(let jsonString, _):
                
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
                
            case .errorInvalidStatusCode:
                call(completion, returning: .errorInvalidStatusCode)
                
            case .errorNoStatusCode:
                call(completion, returning: .errorNoStatusCode)
            }
        }
    }
    
    private static func call(_ completion: @escaping DeleteSessionCompletion, returning result: DeleteSessionResult) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

// MARK: JSON Decoding
extension DeleteSessionRequest {
    
    private static func decode(from jsonString: String) -> UdacityDeletedSession? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormats.server.formatter)
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        var object: UdacityDeletedSession?
        do {
            object = try decoder.decode(UdacityDeletedSession.self, from: jsonData)
        } catch {
            print(error)
            return nil
        }
        
        return object
    }
}

// MARK: Result
enum DeleteSessionResult {
    case success(session: UdacityDeletedSession)
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}
