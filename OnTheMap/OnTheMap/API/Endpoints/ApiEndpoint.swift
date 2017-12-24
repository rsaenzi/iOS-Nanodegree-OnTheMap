//
//  ApiEndpoint.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

// MARK: Endpoints
enum ApiEndpoint {
    
    /// To get multiple student locations at one time
    case getStudentLocations(limit: Int?, skip: Int?, order: String?)
    
    /// To get a single student location
    case getSingleStudent(uniqueKey: String)
    
    /// To create a new student location
    case newStudentLocation(student: NewStudentLocation)
}

// MARK: URL Components
extension ApiEndpoint {
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        switch self {
            
        case .getStudentLocations, .getSingleStudent, .newStudentLocation:
            return "parse.udacity.com"
        }
    }
    
    private var path: String {
        switch self {
            
        case .getStudentLocations, .getSingleStudent, .newStudentLocation:
            return "/parse/classes/StudentLocation"
        }
    }
    
    private var queryItems: [URLQueryItem]? {
        switch self {
            
        case .getStudentLocations(let limit, let skip, let order):
            var queries = [URLQueryItem]()
            
            if let limit = limit {
                queries.append(URLQueryItem(name: "limit", value: "\(limit)"))
            }
            if let skip = skip {
                queries.append(URLQueryItem(name: "skip", value: "\(skip)"))
            }
            if let order = order {
                queries.append(URLQueryItem(name: "order", value: "\(order)"))
            }
            
            guard queries.count > 0 else {
                return nil
            }
            return queries
            
            
        case .getSingleStudent(let uniqueKey):
            let whereQuery = "{\"uniqueKey\":\"\(uniqueKey)\"}".urlEscaped
            return [URLQueryItem(name: "where", value: "\(whereQuery)")]
            
        case .newStudentLocation:
            return nil
        }
    }
    
    var url: URL {
        let url = NSURLComponents()
        url.scheme = self.scheme
        url.host = self.host
        url.path = self.path
        url.queryItems = self.queryItems
        return url.url!
    }
}

// MARK: Request Components
extension ApiEndpoint {
    
    private var httpMethod: String {
        switch self {
            
        case .getStudentLocations, .getSingleStudent:
            return "GET"
            
        case .newStudentLocation:
            return "POST"
        }
    }
    
    private var httpBody: Data? {
        switch self {
            
        case .getStudentLocations, .getSingleStudent:
            return nil
        
        case .newStudentLocation(let student):
            
            guard let jsonString = encodeToJson(student) else {
                return nil
            }
            return jsonString.utf8Encoded
        }
    }
    
    private var headers: [String: String]? {
        
        var headers = [String: String]()
        headers["Accept"] = "application/json"
        headers["Content-type"] = "application/json"
        
        switch self {
        case .getStudentLocations, .getSingleStudent, .newStudentLocation:
            headers["X-Parse-Application-Id"] = parseAppId
            headers["X-Parse-REST-API-Key"] = parseRestApiKey
        }
        
        return headers
    }
    
    var request: URLRequest {
        let request = NSMutableURLRequest()
        request.url = self.url
        request.httpMethod = self.httpMethod
        request.httpBody = self.httpBody
        if let headers = self.headers {
            for (header, value) in headers {
                request.setValue(value, forHTTPHeaderField: header)
            }
        }
        return request as URLRequest
    }
}

// MARK: JSON Encoding
extension ApiEndpoint {
    
    private func encodeToJson<T: Encodable>(_ object: T) -> String? {
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormats.server.formatter)
        encoder.outputFormatting = .prettyPrinted
        
        guard let jsonData = try? encoder.encode(object) else {
            return nil
        }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return nil
        }
        
        guard jsonString.count > 0 else {
            return nil
        }
        
        return jsonString
    }
}

// MARK: - Helpers
private extension String {
    
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
