//
//  GetStudentLocationsRequest.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

typealias GetStudentLocationsCompletion = (_ result: GetStudentLocationsResult) -> ()

// MARK: Request
class GetStudentLocationsRequest {
    
    static func get(limit: Int?, skip: Int?, order: String?, completion: @escaping GetStudentLocationsCompletion) {
        
        let endpoint = ApiEndpoint.getStudentLocations(limit: limit, skip: skip, order: order)
        Request.shared.request(endpoint) { result in
            
            switch result {
            case .success(let jsonString, let statusCode):
                
                guard let locations = decode(from: jsonString) else {
                    call(completion, returning: .errorJsonDecoding)
                    return
                }
                
                call(completion, returning: .success(studentLocations: locations))
                
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
    
    private static func call(_ completion: @escaping GetStudentLocationsCompletion, returning result: GetStudentLocationsResult) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

// MARK: JSON Decoding
extension GetStudentLocationsRequest {
    
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
enum GetStudentLocationsResult {
    case success(studentLocations: StudentResults)
    
    case errorRequest
    case errorDataDecoding
    case errorInvalidStatusCode
    case errorNoStatusCode
    case errorJsonDecoding
}
