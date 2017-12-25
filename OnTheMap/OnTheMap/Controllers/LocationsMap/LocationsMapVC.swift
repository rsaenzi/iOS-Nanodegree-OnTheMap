//
//  LocationsMapVC.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit
import MapKit

class LocationsMapVC: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var buttonLogout: UIBarButtonItem!
    @IBOutlet weak var buttonRefresh: UIBarButtonItem!
    
    @IBAction func onTapLogout(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func onTapRefresh(_ sender: UIBarButtonItem) {
    }
}

extension LocationsMapVC: MKMapViewDelegate {
    
}
