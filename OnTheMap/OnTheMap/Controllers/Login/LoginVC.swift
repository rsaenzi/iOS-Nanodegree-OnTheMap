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
        
        // Sets the delegate of the textfields
        textfieldUsername.delegate = self
        textfieldPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardEvents()
    }
    
    @IBAction func onTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        
        // Dismiss the keyboard
        textfieldUsername.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        
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
        
        // Dismiss the keyboard
        textfieldUsername.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        
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
        
        GetStudentLocationsRequest.get(limit: 100, skip: nil, order: "-updatedAt") { result in
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
        view.frame.origin.y = -getKeyboardHeight(notification) / 2
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
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

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfieldUsername.resignFirstResponder()
        textfieldPassword.resignFirstResponder()
        return true
    }
}
