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
    
    private let viewInitPosition = CGFloat(64)
    
    override func viewDidLoad() {
        waitingMode(enable: false)
        
        // Sets the delegate of the textfields
        textfieldLocationName.delegate = self
        textfieldWebsite.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardEvents()
    }
    
    @IBAction func onTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func onTapFind(_ sender: UIButton, forEvent event: UIEvent) {
        
        // Dismiss the keyboard
        textfieldLocationName.resignFirstResponder()
        textfieldWebsite.resignFirstResponder()
        
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
    
    // MARK: Keyboard handling
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeToKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -getKeyboardHeight(notification) / 3
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = viewInitPosition
    }
    
    private func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        guard let userInfo = notification.userInfo else {
            return 0
        }
        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        return keyboardSize.cgRectValue.height
    }
}

extension AddLocationVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfieldLocationName.resignFirstResponder()
        textfieldWebsite.resignFirstResponder()
        return true
    }
}
