//
//  GetSingleStudentRequest.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias GetSingleStudentCompletion = (_ result: GetSingleStudentResult) -> ()

// MARK: Request
class GetSingleStudentRequest {
    
    static func get(uniqueKey: String, completion: @escaping GetSingleStudentCompletion) {
        
        let endpoint = ApiEndpoint.getSingleStudent(uniqueKey: uniqueKey)
        Request.shared.request(endpoint) { result in
            
            switch result {
            case .success(let jsonString, _):
                
                guard let studentResults = decode(from: jsonString) else {
                    call(completion, returning: .errorJsonDecoding)
                    return
                }
                
                call(completion, returning: .success(studentResults: studentResults))
                
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
    
    private static func call(_ completion: @escaping GetSingleStudentCompletion, returning result: GetSingleStudentResult) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

// MARK: JSON Decoding
extension GetSingleStudentRequest {
    
    private static func decode(from jsonString: String) -> StudentResults? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormats.server.formatter)
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        var object: StudentResults?
        do {
            object = try decoder.decode(StudentResults.self, from: jsonData)
        } catch {
            print(error)
            return nil
        }
        
        return object
    }
}

// MARK: Result
enum GetSingleStudentResult {
    case success(studentResults: StudentResults)
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}
