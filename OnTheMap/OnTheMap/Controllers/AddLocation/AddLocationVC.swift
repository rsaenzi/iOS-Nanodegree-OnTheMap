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
    
    private var locationName = ""
    private var profileURL = ""
    private var geocodedLocation = CLLocationCoordinate2D()
    
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
        getCoordinates(from: locationName, profileURL)
    }
    
    private func getCoordinates(from locationName: String, _ profileURL: String) {
        
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
            
            self.locationName = locationName
            self.profileURL = profileURL
            self.geocodedLocation = location.coordinate
            
            self.performSegue(withIdentifier: "GoToSetMapPin", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "GoToSetMapPin",
            let screen = segue.destination as? SetMapPinVC else {
                
            showAlert("Error when trying to display the geocoded location")
            return
        }
        
        screen.locationName = locationName
        screen.profileURL = profileURL
        screen.geocodedLocation = geocodedLocation
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
        
        buttonCancel.isEnabled = !enable
    }
}
