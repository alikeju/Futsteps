//
//  AddOrganizationViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/3/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

//import Foundation
//import UIKit
//import FirebaseDatabase
//
//class AddOrganizationViewController: UITableViewController, UISearchResultsUpdating{
//    
//    let searchController = UISearchController(searchResultsController: nil)
//    var databaseRef = Database.database().reference()
//    
//    @IBOutlet var searchTableView: UITableView!
//    
//    var orgArray = [NSDictionary?]()
//    var filteredOrgs = [NSDictionary]()
//    var otherOrg:Organization?
//    
//    let uid: String
//    let organization: String
//    
//    init?(snapshot: DataSnapshot) {
//        guard let dict = snapshot.value as? [Organization : Any],
//            let organization = dict["organization"] as? Organization
//            //Turn everything in organization 
//            else { return nil }
//        
//        self.uid = snapshot.key
//        self.organization = organization
//    }
//    //parse everything as an organization so you can get each individual as an organization
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        tableView.tableHeaderView = searchController.searchBar
//        
//        databaseRef.child("organizations").queryOrdered(byChild: "organization").observe(.childAdded, with: {(snapshot) in
//        //databaseRef.child("organizations").child("organization").observeSingleEvent(of: .value, with: {(snapshot) in
//
//           // let snapshot = snapshot.value as! Organization
//            if let snapshot = Organization(snapshot: snapshot) as? [String:Any] {
//                print("\(snapshot)")
//            //self.orgArray.append(snapshot)
//            } else {return} 
////            self.searchTableView.insertRows(at: [IndexPath(row: self.orgArray.count-1, section: 0)], with:
////                UITableViewRowAnimation.automatic)
////
////            
//            let key = snapshot.key
//            let snapshot = snapshot.value as? Organization
//            snapshot?.setValue(key, forKey: "uid")
////
////            //Saving dictionary value into otherOrg
////            self.otherOrg = snapshot
////            print(self.otherOrg ?? "Returns nil")
////            
////            
////            self.orgArray.append(snapshot)
////            print(self.orgArray)
//            self.tableView.insertRows(at: [IndexPath(row:self.orgArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
//            //inserting the rows
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        // remove separators for empty cells
//        tableView.tableFooterView = UIView()
//        tableView.rowHeight = 71
//        //HIDES BACK BUTTON. VERY IMPORTANT LINE!!!
//        navigationItem.setHidesBackButton(true, animated: false)
//        
//    }
//
//    @IBAction func addButtonTapped(_ sender: Any) {
//        print("add button tapped")
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchController.isActive && searchController.searchBar.text != ""{
//            //If the users are typing something only show the filtered users.
//            return filteredOrgs.count
//        }
//        return self.orgArray.count
//        //If the users are not typing anything return all the users.
//    }
//
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AddOrgCell") as! AddOrgCell
//        cell.delegate = self as! AddOrgCellDelegate
// 
//        configure(cell: cell, atIndexPath: indexPath)
//        
//        return cell
//        
//        let org: NSDictionary?
//        if searchController.isActive && searchController.searchBar.text != ""{
//            org = filteredOrgs[indexPath.row]
//        } else{
//            org = self.orgArray[indexPath.row]
//        }
//        let organization = orgArray[indexPath.row]
//        //STOP TRYING TO GET ORGANIZATION TO GET ORGANIZATION BECAUSE IT AIN'T
//        cell.textLabel?.text = organization.
//        
//        return cell
//    }
//    
//    func updateSearchResults(for searchController: UISearchController) {
//        filterContent(searchText: self.searchController.searchBar.text!)
//        
//    }
//    
////    func filterContent(searchText:String){
////        self.filteredOrgs = self.orgArray.filter{ org in
////            let orgName = org.organization
////            return(orgName.lowercased().contains(searchText.lowercased()))
////        }
////        tableView.reloadData()
////    }
//    
//        func filterContent(searchText:String){
//            self.filteredOrgs = self.orgArray.filter{ user in
//                let orgName = user!["organization"] as? String
//                return(orgName?.lowercased().contains(searchText.lowercased()))!
//            } as! [NSDictionary]
//            tableView.reloadData()
//        }
//    
//    
//}
////
//extension AddOrganizationViewController{
//    func configure(cell: AddOrgCell, atIndexPath indexPath: IndexPath) {
//        let org = orgArray[indexPath.row]
//        
//        cell.orgNameLabel.text = org.organization
//    }
//}
//
