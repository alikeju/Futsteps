//
//  AddOrgViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/31/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class AddOrgTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var findOrgsTableView: UITableView!
    
    var loggedInUser:FIRUser?
    var member: Member?
    var orgProfile1: Organization?
    var orgProfile:NSDictionary?
    let searchController = UISearchController(searchResultsController: nil)
    var orgArray = [NSDictionary?]()
    var filteredOrgs = [NSDictionary?]()
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        //allows the class to know zwhen the text inside the search bar is changed
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        //making sure that the search bar is only being shown on this view controller and not on another one.
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        databaseRef.child("organizations").queryOrdered(byChild: "organization_name").observe(.childAdded, with: { (snapshot) in
            //the key is the user's UID
            let key = snapshot.key
            let snapshot1 = snapshot.value as? NSDictionary
            self.orgProfile1 = Organization(snapshot: snapshot)
            snapshot1?.setValue(key, forKey: "uid")
            
            if(key == self.loggedInUser?.uid)
            {
                
            }
            else
            {
                self.orgArray.append(snapshot1)
                self.findOrgsTableView.insertRows(at: [IndexPath(row:self.orgArray.count-1, section:0)], with: UITableViewRowAnimation.automatic)
            }
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
    }
    
    @IBAction func createOrgButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Create Organization",
                                      message: "Enter Organization Info",
                                      preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let email = alert.textFields![0]
            let username = alert.textFields![1]
            let password = alert.textFields![2]
            
            //    let memberUID = String()
            print(email.text!)
            
            AuthService.createUser(controller: self, email: email.text!, password: password.text!) { (authOrg) in
                guard let firOrg = authOrg else {
                    return
                }
                
                OrganizationService.createOrg(firOrg, username: username.text!, organization_name: username.text!, member_uid: Member.current.uid) { (user) in
                    guard let user = user else {
                        return
                    }
                }
            }
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Enter Organization Email"
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Enter Organization Name"
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Create Access Code"
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredOrgs.count
        }
        return self.orgArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let org : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            org = filteredOrgs[indexPath.row]
        } else{
            org = self.orgArray[indexPath.row]
        }
        
        cell.textLabel?.text = org?["organization_name"] as? String
        cell.detailTextLabel?.text = org?["type"] as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Join Organization",
                                      message: "",
                                      preferredStyle: .alert)
        
        let joinAction = UIAlertAction(title: "Join", style: .default, handler: { (action) -> Void in
           // let password = alert.textFields![0]
            let addee = self.orgProfile1!
            AddService.setIsAdded(!addee.isAdded, fromCurrentUserTo: addee) { (success) in
                defer {
                    //  self.addButton.isUserInteractionEnabled = true
                }
                
                guard success else { return }
                
                addee.isAdded = !addee.isAdded
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        })
        
//        alert.addTextField { (textField: UITextField) in
//            textField.keyboardAppearance = .dark
//            textField.keyboardType = .default
//            textField.placeholder = "Enter Access Code"
//            textField.isSecureTextEntry = true
//            textField.textColor = UIColor.black
//        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(joinAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
        
    }
    
    func filterContent(searchText: String){
        self.filteredOrgs = self.orgArray.filter{ org in
            let orgName = org!["organization_name"] as? String
            return(orgName?.lowercased().contains(searchText.lowercased()))!
        }
        
        
        tableView.reloadData()
    }
}

