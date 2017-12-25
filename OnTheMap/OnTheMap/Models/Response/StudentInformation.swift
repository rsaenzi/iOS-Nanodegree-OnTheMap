//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

struct StudentResults: Codable {
    let results: [StudentInformation]
}

struct StudentInformation: Codable {
    let objectId: String?
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
}
