//
//  DateFormats.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/23/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

enum DateFormats: String {
    case server = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    var formatter: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = self.rawValue
        return format
    }
}
