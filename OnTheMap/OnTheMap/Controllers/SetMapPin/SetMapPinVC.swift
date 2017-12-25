//
//  SetMapPinVC.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit
import MapKit

class SetMapPinVC: UIViewController {
    
    @IBOutlet weak var buttonFinish: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func onTapFinish(_ sender: UIButton, forEvent event: UIEvent) {
        
    }
}

extension SetMapPinVC: MKMapViewDelegate {
    
}
