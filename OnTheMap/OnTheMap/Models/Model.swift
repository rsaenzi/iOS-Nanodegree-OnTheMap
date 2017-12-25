//
//  Model.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation

class Model {
    static let shared = Model()
    
    var session: UdacitySession?
    var students = [StudentInformation]()
}
