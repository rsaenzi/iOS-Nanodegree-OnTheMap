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
        map.addAnnotations(Model.shared.getLocations())
    }
    
    @IBAction func onTapLogout(_ sender: UIBarButtonItem) {
        logOut()
    }
    
    @IBAction func onTapRefresh(_ sender: UIBarButtonItem) {
        getStudentLocations()
    }
    
    private func getStudentLocations() {
        
        waitingMode(enable: true)
        
        GetStudentLocationsRequest.get(limit: 100, skip: nil, order: "-updatedAt") { result in
            switch result {
                
            case .success(let studentLocations):
                
                // Remove any previous locations
                self.map.removeAnnotations(Model.shared.getLocations())
                
                // Add the new locations
                Model.shared.set(students: studentLocations.results)
                self.map.addAnnotations(Model.shared.getLocations())
                
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
                
            case .success:
                
                Model.shared.session = nil
                Model.shared.set(students: [])
                
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
}

extension LocationsMapVC: MKMapViewDelegate {
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = #colorLiteral(red: 0.003010978457, green: 0.7032318711, blue: 0.895259738, alpha: 1)
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard control == view.rightCalloutAccessoryView else {
            return
        }
        guard let link = view.annotation?.subtitle, let url = URL(string: link!),
                UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}
