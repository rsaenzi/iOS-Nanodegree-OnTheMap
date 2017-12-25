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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let student = Model.shared.students[indexPath.row]
        
        guard let link = student.mediaURL, let url = URL(string: link),
                UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
}

extension LocationsListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let student = Model.shared.students[indexPath.row]
        let cell: LocationsListCell = tableView.dequeue(indexPath)
        
        let firstName = student.firstName ?? ""
        let lastName = student.lastName ?? ""
        
        cell.labelName.text = firstName + "" + lastName
        cell.labelWebsite.text = student.mediaURL
        
        return cell
    }
}
