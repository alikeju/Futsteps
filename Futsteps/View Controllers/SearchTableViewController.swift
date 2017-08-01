//
//  SearchTableViewController.swift
//
//
//  Created by Alikeju Adejo on 7/28/17.
//
//

import UIKit
import FirebaseDatabase

class SearchTableViewController: UITableViewController, UISearchResultsUpdating{
    
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet var searchOrgTableView: UITableView!
    
    var orgArray = [NSDictionary?]()
    var filteredOrgs = [NSDictionary?]()
    var loggedInOrg:FIRUser?
    
    var databaseRef = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        databaseRef.child("organizations").queryOrdered(byChild: "organization").observe(.childAdded, with: {(snapshot) in
            
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
            self.orgArray.append(snapshot)
            
//Check 15:40 in the video just in case I actually need to add line
            
            //inserting the rows
            
            self.searchOrgTableView.insertRows(at: [IndexPath(row:self.orgArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Uncomment the following line to preserve selection between presentations
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
            //If the users are typing something only show the filtered users.
            return filteredOrgs.count
        }
        return self.orgArray.count
        //If the users are not typing anything return all the users.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let org: NSDictionary?
        if searchController.isActive && searchController.searchBar.text != ""{
            org = filteredOrgs[indexPath.row]
        } else{
            org = self.orgArray[indexPath.row]
        }
        cell.textLabel?.text = org?["organization"] as? String
        cell.detailTextLabel?.text = org?["handle"] as? String
        
        return cell
    }
    
    @IBAction func dismissOrgViewTableView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
        
    }
    
    func filterContent(searchText:String){
        self.filteredOrgs = self.orgArray.filter{ user in
            let orgName = user!["organization"] as? String
            return(orgName?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showCreateViewController = segue.destination as! CreateViewController
        showCreateViewController.loggedInOrg = self.loggedInOrg
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let org = orgArray[indexPath.row]
            showCreateViewController.org = org
        }
    }
    
}
