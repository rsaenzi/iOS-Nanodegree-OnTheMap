//
//  LocationsListVC.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class LocationsListVC: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var buttonLogout: UIBarButtonItem!
    @IBOutlet weak var buttonRefresh: UIBarButtonItem!
    
    @IBAction func onTapLogout(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func onTapRefresh(_ sender: UIBarButtonItem) {
    }
}

extension LocationsListVC: UITableViewDelegate {
    
}

extension LocationsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
