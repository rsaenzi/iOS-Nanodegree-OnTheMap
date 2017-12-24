//
//  ApiEndpoint.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

// MARK: API Keys
private let parseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
private let parseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

// MARK: Endpoints
enum ApiEndpoint {
    
    /// To get multiple student locations at one time
    case getStudentLocations(limit: Int?, skip: Int?, order: String?)
    
    /// To get a single student location
    case getSingleStudent(uniqueKey: String)
    
    /// To create a new student location
    case newStudentLocation(student: NewStudentLocation)
    
    /// To update an existing student location
    case editStudentLocation(objectId: String, fieldsToEdit: [String: String])
    
    /// Get a session ID from Udacity
    case getSessionId(username: String, password: String)
    
    /// Delete a session ID from Udacity
    case deleteSession
    
    /// Retrieve some basic user information from Udacity
    case getUserData(userId: String)
}

// MARK: URL Components
extension ApiEndpoint {
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        switch self {
            
        case .getStudentLocations, .getSingleStudent, .newStudentLocation, .editStudentLocation:
            return "parse.udacity.com"
            
        case .getSessionId, .deleteSession, .getUserData:
            return "www.udacity.com"
        }
    }
    
    private var path: String {
        switch self {
            
        case .getStudentLocations, .getSingleStudent, .newStudentLocation:
            return "/parse/classes/StudentLocation"
            
        case .editStudentLocation(let objectId, _):
            return "/parse/classes/StudentLocation/\(objectId)"
            
        case .getSessionId, .deleteSession:
            return "/api/session"
            
        case .getUserData(let userId):
            return "/api/users/\(userId)"
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
            
        case .newStudentLocation, .editStudentLocation, .getSessionId, .deleteSession, .getUserData:
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
            
        case .getStudentLocations, .getSingleStudent, .getUserData:
            return "GET"
            
        case .newStudentLocation, .getSessionId:
            return "POST"
            
        case .editStudentLocation:
            return "PUT"
            
        case .deleteSession:
            return "DELETE"
        }
    }
    
    private var httpBody: Data? {
        switch self {
            
        case .getStudentLocations, .getSingleStudent, .deleteSession, .getUserData:
            return nil
        
        case .newStudentLocation(let student):
            guard let jsonString = encodeToJson(student) else {
                return nil
            }
            return jsonString.utf8Encoded
            
        case .editStudentLocation(_, let editFields):
            guard let jsonData = try? JSONSerialization.data(withJSONObject: editFields, options: .prettyPrinted) else {
                return nil
            }
            
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                return nil
            }
            
            return jsonString.utf8Encoded
            
        case .getSessionId(let username, let password):
            
            let credentials = SessionCredentials(username: username, password: password)
            let requestBody = SessionRequest(udacity: credentials)
            
            guard let jsonString = encodeToJson(requestBody) else {
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
        case .getSessionId, .getUserData:
            break
            
        case .getStudentLocations, .getSingleStudent, .newStudentLocation, .editStudentLocation:
            headers["X-Parse-Application-Id"] = parseAppId
            headers["X-Parse-REST-API-Key"] = parseRestApiKey
            
        case .deleteSession:
            
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                headers["X-XSRF-TOKEN"] = xsrfCookie.value
            }
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

// MARK: JSON Request Objects
private struct SessionRequest: Codable {
    let udacity: SessionCredentials
}

private struct SessionCredentials: Codable {
    let username: String
    let password: String
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
