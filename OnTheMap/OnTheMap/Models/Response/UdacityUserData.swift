//
//  UdacityUserData.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

struct UdacityUserData: Codable {
    let user: UdacityUser
}

struct UdacityUser: Codable {
    let key: String
    let lastName: String?
    let firstName: String?
    let linkedinUrl: String?
    let googleId: String?
    
    // MARK: Decoding & Encoding to JSON
    enum CodingKeys: String, CodingKey {
        case key
        case lastName = "last_name"
        case firstName = "first_name"
        case linkedinUrl = "linkedin_url"
        case googleId = "_google_id"
    }
}
