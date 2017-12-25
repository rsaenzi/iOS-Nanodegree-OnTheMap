//
//  EditStudentLocationRequest.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias EditStudentLocationCompletion = (_ result: EditStudentLocationResult) -> ()

// MARK: Request
class EditStudentLocationRequest {
    
    static func put(objectId: String, fieldsToEdit: [String: String], completion: @escaping EditStudentLocationCompletion) {
        
        let endpoint = ApiEndpoint.editStudentLocation(objectId: objectId, fieldsToEdit: fieldsToEdit)
        Request.shared.request(endpoint) { result in
            
            switch result {
            case .success(let jsonString):
                
//                guard let studentResults = decode(from: jsonString) else { // TODO here
//                    call(completion, returning: .errorJsonDecoding)
//                    return
//                }
                
                call(completion, returning: .success)
                
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
    
    private static func call(_ completion: @escaping EditStudentLocationCompletion, returning result: EditStudentLocationResult) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

// MARK: JSON Decoding
//extension EditStudentLocationRequest {
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
enum EditStudentLocationResult {
    case success
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}
