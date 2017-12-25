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
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var buttonLogout: UIBarButtonItem!
    @IBOutlet weak var buttonRefresh: UIBarButtonItem!
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    
    override func viewDidLoad() {
        waitingMode(enable: false)
    }
    
    @IBAction func onTapLogout(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func onTapRefresh(_ sender: UIBarButtonItem) {
        waitingMode(enable: true)
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
        
        buttonLogout.isEnabled = !enable
        buttonRefresh.isEnabled = !enable
        buttonAdd.isEnabled = !enable
    }
}

extension LocationsMapVC: MKMapViewDelegate {
    
}
