//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    override func viewDidLoad() {
        waitingMode(enable: false)
    }
    
    @IBAction func onTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        guard let username = textfieldUsername.text, username.count > 0 else {
            showAlert("Please enter a valid Udacity Username")
            return
        }
        guard let password = textfieldPassword.text, password.count > 0 else {
            showAlert("Please enter a password")
            return
        }
        getSession(username: username, password: password)
    }
    
    @IBAction func onTapSignUp(_ sender: UIButton, forEvent event: UIEvent) {
        
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
                UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    private func getSession(username: String, password: String) {
        
        waitingMode(enable: true)
        
        GetSessionIdRequest.post(username: username, password: password) { result in
            switch result {
                
            case .success(let session):
                Model.shared.session = session
                self.getUserInfo()
                
            case .invalidCredentials:
                self.waitingMode(enable: false)
                self.showAlert("Account not found or invalid credentials")
                
            default:
                self.waitingMode(enable: false)
                self.showAlert("Error on Login")
            }
        }
    }
    
    private func getUserInfo() {
        
        guard let userId = Model.shared.session?.account.key else {
            self.waitingMode(enable: false)
            self.showAlert("Error on fetching user data")
            return
        }
        
        GetUserDataRequest.get(userId: userId) { result in
            switch result {
                
            case .success(let userData):
                Model.shared.userData = userData
                self.getStudentLocations()
                
            default:
                self.waitingMode(enable: false)
                self.showAlert("Error on fetching user data")
            }
        }
    }
    
    private func getStudentLocations() {
        
        GetStudentLocationsRequest.get(limit: 100, skip: nil, order: "-createdAt") { result in
            switch result {
                
            case .success(let studentLocations):
                Model.shared.set(students: studentLocations.results)
                self.waitingMode(enable: false)
                self.performSegue(withIdentifier: "ShowTabBar", sender: self)
                
            default:
                self.waitingMode(enable: false)
                self.showAlert("Error fetching student locations")
            }
        }
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
    }
}
