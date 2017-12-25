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
    
    var locationName = ""
    var profileURL = ""
    var geocodedLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        waitingMode(enable: false)
        
        let point = MKPointAnnotation()
        point.title = locationName
        point.coordinate = geocodedLocation
        map.addAnnotation(point)
    }
    
    @IBAction func onTapFinish(_ sender: UIButton, forEvent event: UIEvent) {
        addStudent()
    }
    
    private func addStudent() {
        
        let newLocation = StudentInformation(
            objectId: nil,
            uniqueKey: Model.shared.session?.account.key,
            firstName: Model.shared.userData?.user.firstName,
            lastName: Model.shared.userData?.user.lastName,
            mapString: locationName,
            mediaURL: profileURL,
            latitude: geocodedLocation.latitude,
            longitude: geocodedLocation.longitude)
        
        waitingMode(enable: true)
        
        NewStudentLocationRequest.post(newStudent: newLocation) { result in
            
            self.waitingMode(enable: false)
            
            switch result {
                
            case .success:
                self.navigationController?.dismiss(animated: true)
                
            default:
                self.showAlert("Error on adding student location")
            }
        }
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(actionOk)
        present(alert, animated: true)
    }
}

extension SetMapPinVC: MKMapViewDelegate {
}
