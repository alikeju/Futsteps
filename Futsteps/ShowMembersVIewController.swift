//
//  showMembersVIewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 9/4/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ShowMembersViewController: UITableViewController{
    
    
    var orgProfile:NSDictionary?
    var loggedInUser:FIRUser?
    var memberArray = [NSDictionary?]()
    var databaseRef = Database.database().reference()
    @IBOutlet var showMembersTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef.child("organizations_of_members").child(Member.current.org_uid!).queryOrdered(byChild: "member").observe(.childAdded, with: { (snapshot) in
            //the key is the user's UID
            let key = snapshot.key
            let snapshot1 = snapshot.value as? NSDictionary
            snapshot1?.setValue(key, forKey: "uid")
            
            self.memberArray.append(snapshot1)
            self.showMembersTableView.insertRows(at: [IndexPath(row:self.memberArray.count-1, section:0)], with: UITableViewRowAnimation.automatic)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memberArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let member : NSDictionary?
        member = self.memberArray[indexPath.row]
        cell.textLabel?.text = member?["member"] as? String
        cell.detailTextLabel?.text = member?["type"] as? String
        
        return cell
    }
}
