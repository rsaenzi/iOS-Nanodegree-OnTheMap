//
//  Model.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import Foundation
import MapKit

class Model {
    static let shared = Model()
    
    var session: UdacitySession?
    var userData: UdacityUserData?
    
    private var locations = [MKPointAnnotation]()
    private var students = [StudentInformation]()
    
    func getStudents() -> [StudentInformation] {
        return students
    }
    
    func getLocations() -> [MKPointAnnotation] {
        return locations
    }
    
    func set(students: [StudentInformation]) {
        self.students = students
        
        // Here we create the map annotations
        locations = students.map({ student -> MKPointAnnotation in
            
            let firstName = student.firstName ?? ""
            let lastName = student.lastName ?? ""
            
            let latitude = CLLocationDegrees(student.latitude ?? 0)
            let longitude = CLLocationDegrees(student.longitude ?? 0)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let point = MKPointAnnotation()
            point.title = firstName + "" + lastName
            point.subtitle = student.mediaURL
            point.coordinate = coordinate
            
            return point
        })
    }
}
