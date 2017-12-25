//
//  LocationsListVC.swift
//  OnTheMap
//
//  Created by Rigoberto Sáenz Imbacuán on 12/24/17.
//  Copyright © 2017 Rigoberto Sáenz Imbacuán. All rights reserved.
//

import UIKit

class LocationsListVC: UIViewController {
    
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var buttonLogout: UIBarButtonItem!
    @IBOutlet weak var buttonRefresh: UIBarButtonItem!
    @IBOutlet weak var buttonAdd: UIBarButtonItem!
    
    override func viewDidLoad() {
        waitingMode(enable: false)
    }
    
    @IBAction func onTapLogout(_ sender: UIBarButtonItem) {
        logOut()
    }
    
    @IBAction func onTapRefresh(_ sender: UIBarButtonItem) {
        getStudentLocations()
    }
    
    private func getStudentLocations() {
        
        waitingMode(enable: true)
        
        GetStudentLocationsRequest.get(limit: 100, skip: nil, order: nil) { result in
            switch result {
                
            case .success(let studentLocations):
                Model.shared.students = studentLocations.results
                self.table.reloadData()
                
            default:
                self.showAlert("Error fetching student locations")
            }
            self.waitingMode(enable: false)
        }
    }
    
    private func logOut() {
        
        waitingMode(enable: true)
        
        DeleteSessionRequest.post { result in
            switch result {
                
            case .success(let session):
                
                Model.shared.session = nil
                Model.shared.students = []
                
                self.waitingMode(enable: false)
                self.dismiss(animated: true)
                
            default:
                self.showAlert("Error on Logout")
            }
        }
    }
    
    private func waitingMode(enable: Bool) {
        waitingView.isHidden = !enable
        
        buttonLogout.isEnabled = !enable
        buttonRefresh.isEnabled = !enable
        buttonAdd.isEnabled = !enable
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .default)
        alert.addAction(actionOk)
        present(alert, animated: true)
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
