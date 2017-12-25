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
        logOut()
    }
    
    @IBAction func onTapRefresh(_ sender: UIBarButtonItem) {
        getStudentLocations()
    }
    
    private func getStudentLocations() {
        
        waitingMode(enable: true)
        
        GetStudentLocationsRequest.get(limit: 100, skip: nil, order: nil) { result in
            switch result {
                
            case .success(let studentLocations):
                Model.shared.students = studentLocations.results
                
                // TODO Reload map points
                
            default:
                self.showAlert("Error fetching student locations")
            }
            self.waitingMode(enable: false)
        }
    }
    
    private func logOut() {
        
        waitingMode(enable: true)
        
        DeleteSessionRequest.post { result in
            switch result {
                
            case .success(let session):
                
                Model.shared.session = nil
                Model.shared.students = []
                
                self.waitingMode(enable: false)
                self.dismiss(animated: true)
                
            default:
                self.showAlert("Error on Logout")
            }
        }
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
        
        buttonLogout.isEnabled = !enable
        buttonRefresh.isEnabled = !enable
        buttonAdd.isEnabled = !enable
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(actionOk)
        present(alert, animated: true)
    }
}

extension LocationsMapVC: MKMapViewDelegate {
    
}
