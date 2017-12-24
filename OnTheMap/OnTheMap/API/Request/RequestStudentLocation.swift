//
//  RequestStudentLocation.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias StudentLocationCompletion = (_ result: StudentLocationResult) -> ()

class RequestStudentLocation {
    static let shared = RequestStudentLocation()
    
    func get(completion: @escaping StudentLocationCompletion) {
        
        let endpoint = ApiEndpoint.studentLocation(limit: 3, skip: nil, order: nil)
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

enum StudentLocationResult {
    case success(studentResults: StudentResults)
    
    case errorRequest
    case errorDataDecoding
    
    case errorJsonDecoding
}
