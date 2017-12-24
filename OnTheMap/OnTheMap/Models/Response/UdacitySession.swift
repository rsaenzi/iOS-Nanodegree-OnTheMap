//
//  UdacitySession.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

struct UdacitySession: Codable {
    let account: UdacityAccount
    let session: UdacitySessionInfo
}

struct UdacityAccount: Codable {
    let registered: Bool
    let key: String
}

struct UdacitySessionInfo: Codable {
    let id: String
    let expiration: Date
}

struct UdacityDeletedSession: Codable {
    let session: UdacitySessionInfo
}
