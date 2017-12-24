//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var textfieldUsername: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    
    @IBAction func onTapLogin(_ sender: UIButton, forEvent event: UIEvent) {
        
    }
    
    @IBAction func onTapSignUp(_ sender: UIButton, forEvent event: UIEvent) {
        
        guard let url = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(url) else {
                return
        }
        UIApplication.shared.open(url, options: [:])
    }
}
