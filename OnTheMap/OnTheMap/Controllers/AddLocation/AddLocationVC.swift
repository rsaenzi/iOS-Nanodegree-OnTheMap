//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

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
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
        
        buttonCancel.isEnabled = !enable
    }
}
