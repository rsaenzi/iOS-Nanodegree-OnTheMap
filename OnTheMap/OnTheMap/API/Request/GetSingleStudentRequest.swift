//
//  GetSingleStudentRequest.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias GetSingleStudentCompletion = (_ result: GetSingleStudentResult) -> ()

class GetSingleStudentRequest {
    
    static let shared = GetSingleStudentRequest()
    
    func get(uniqueKey: String, completion: @escaping GetSingleStudentCompletion) {
        
        let endpoint = ApiEndpoint.getSingleStudent(uniqueKey: uniqueKey)
        Network.shared.request(endpoint) { networkResult in
            
            switch networkResult {
            case .success(let jsonString):
                
                guard let studentResults = self.decode(from: jsonString) else {
                    completion(.errorJsonDecoding)
                    return
                }
                
                completion(.success(studentResults: studentResults))
                
            case .errorRequest:
                completion(.errorRequest)
                
            case .errorDataDecoding:
                completion(.errorDataDecoding)
                
            case .errorInvalidStatusCode:
                completion(.errorInvalidStatusCode)
            }
        }
    }
    
    private func decode(from jsonString: String) -> StudentResults? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormats.server.formatter)
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        
        guard let object = try? decoder.decode(StudentResults.self, from: jsonData) else {
            return nil
        }
        
        return object
    }
}

enum GetSingleStudentResult {
    case success(studentResults: StudentResults)
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    
    case errorJsonDecoding
}
