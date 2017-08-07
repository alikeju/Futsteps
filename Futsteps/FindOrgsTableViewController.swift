//
//  FindOrgsTableTableViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/5/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FindOrgsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var findOrgsTableView: UITableView!
    
    var loggedInUser:FIRUser?
    let searchController = UISearchController(searchResultsController: nil)
    var orgArray = [NSDictionary?]()
    var filteredOrgs = [NSDictionary?]()
    var databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //allows the class to know when the text inside the search bar is changed
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        //making sure that the search bar is only being shown on this view controller and not on another one.
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        databaseRef.child("organizations").queryOrdered(byChild: "organization_name").observe(.childAdded, with: { (snapshot) in
            //the key is the user's UID
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            
            snapshot?.setValue(key, forKey: "uid")
            
            if(key == self.loggedInUser?.uid)
            {
                print("Same as logged in user, so don't show!")
            }
            else
            {
            
            self.orgArray.append(snapshot)
            self.findOrgsTableView.insertRows(at: [IndexPath(row:self.orgArray.count-1, section:0)], with: UITableViewRowAnimation.automatic)
            }
        }) { (error) in
            print(error.localizedDescription)
            
        }// Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showOrgProfileViewController = segue.destination as! OrgProfileViewController
        
        showOrgProfileViewController.loggedInUser = self.loggedInUser
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let org = orgArray[indexPath.row]
            showOrgProfileViewController.orgProfile = org
        }
        
    }
    
}
