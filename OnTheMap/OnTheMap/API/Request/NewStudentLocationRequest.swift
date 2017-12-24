//
//  NewStudentLocationRequest.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias NewStudentLocationCompletion = (_ result: NewStudentLocationResult) -> ()

// MARK: Request
class NewStudentLocationRequest {
    
    static let shared = NewStudentLocationRequest()
 
    func post(newStudent: NewStudentLocation, completion: @escaping NewStudentLocationCompletion) {
        
        let endpoint = ApiEndpoint.newStudentLocation(student: newStudent)
        Request.shared.request(endpoint, successStatusCode: 201) { result in
            
            switch result {
            case .success(let jsonString):
                
//                guard let studentResults = self.decode(from: jsonString) else { // TODO here
//                    completion(.errorJsonDecoding)
//                    return
//                }
                
                completion(.success)
                
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
//extension NewStudentLocationRequest {
//
//    private func decode(from jsonString: String) -> StudentResults? { // TODO objeto response aqui
//
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .formatted(DateFormats.server.formatter)
//
//        guard let jsonData = jsonString.data(using: .utf8) else {
//            return nil
//        }
//
//        guard let object = try? decoder.decode(StudentResults.self, from: jsonData) else {
//            return nil
//        }
//
//        return object
//    }
//}

// MARK: Result
enum NewStudentLocationResult {
    case success
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}
