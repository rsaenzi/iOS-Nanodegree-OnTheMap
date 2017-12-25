//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationVC: UIViewController {
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    @IBOutlet weak var textfieldLocationName: UITextField!
    @IBOutlet weak var textfieldWebsite: UITextField!
    @IBOutlet weak var buttonFind: UIButton!
    
    override func viewDidLoad() {
        waitingMode(enable: false)
    }
    
    @IBAction func onTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func onTapFind(_ sender: UIButton, forEvent event: UIEvent) {
        
        guard let locationName = textfieldLocationName.text, locationName.count > 0 else {
            showAlert("Please enter a valid Location")
            return
        }
        guard let profileURL = textfieldWebsite.text, profileURL.count > 0 else {
            showAlert("Please enter a valid URL")
            return
        }
        getCoordinates(from: locationName)
    }
    
    private func getCoordinates(from locationName: String) {
        
        waitingMode(enable: true)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { placemarks, error in
            
            self.waitingMode(enable: false)
            
            if let _ = error {
                self.showAlert("We could not find the place \(locationName)")
                return
            }
            
            guard let placemarks = placemarks, let firstPlace = placemarks.first else {
                self.showAlert("Could not find any placemarks for place \(locationName)")
                return
            }
            
            guard let location = firstPlace.location else {
                self.showAlert("Could not find coordinates for place \(locationName)")
                return
            }
            
            self.performSegue(withIdentifier: "GoToSetMapPin", sender: location)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "GoToSetMapPin",
            let screen = segue.destination as? SetMapPinVC,
            let location = sender as? CLLocation else {
                
            showAlert("Error when trying to display the geocoded location")
            return
        }
        screen.geocodedLocation = location
    }
    
    private func addStudent(locationName: String, profileURL: String) {
        
//        waitingMode(enable: true)
//
//        let newLocation = StudentInformation(
//            objectId: nil,
//            uniqueKey: Model.shared.session?.account.key,
//            firstName: "",
//            lastName: "",
//            mapString: locationName,
//            mediaURL: profileURL,
//            latitude: 0.0,
//            longitude: 0.0)
//
//        NewStudentLocationRequest.post(newStudent: newLocation) { result in
//            self.waitingMode(enable: false)
//
//            switch result {
//
//            case .success:
//                self.performSegue(withIdentifier: "", sender: self)
//
//            default:
//                self.showAlert("Error on Login")
//            }
//        }
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
        
        buttonCancel.isEnabled = !enable
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(actionOk)
        present(alert, animated: true)
    }
}
