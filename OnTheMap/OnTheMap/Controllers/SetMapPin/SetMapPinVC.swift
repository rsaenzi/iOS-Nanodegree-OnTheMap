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
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var buttonFinish: UIButton!
    
    var geocodedLocation: CLLocation?
    
    override func viewDidLoad() {
        waitingMode(enable: false)
    }
    
    @IBAction func onTapFinish(_ sender: UIButton, forEvent event: UIEvent) {
        navigationController?.dismiss(animated: true)
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
    }
}

extension SetMapPinVC: MKMapViewDelegate {
    
}
