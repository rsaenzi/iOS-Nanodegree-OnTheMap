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
 
    static func post(newStudent: StudentInformation, completion: @escaping NewStudentLocationCompletion) {
        
        let endpoint = ApiEndpoint.newStudentLocation(student: newStudent)
        Request.shared.request(endpoint, successStatusCode: 201) { result in
            
            switch result {
            case .success:
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
    
    private static func call(_ completion: @escaping NewStudentLocationCompletion, returning result: NewStudentLocationResult) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

// MARK: Result
enum NewStudentLocationResult {
    case success
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}
