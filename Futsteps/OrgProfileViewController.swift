//
//  OrgProfileViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/7/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import UIKit
import Firebase


class OrgProfileViewController: UIViewController {
    
    var loggedInUser:FIRUser?
    var orgProfile:NSDictionary?
    var databaseRef:DatabaseReference!
    var loggedInUserData:NSDictionary?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseRef = Database.database().reference()
        
        
        //add an observer for the logged in user
        //whenever the member profiles changes it is going to change the loggedInUserData
        databaseRef.child("member_profiles").child(self.loggedInUser!.uid).observe(.value, with: { (snapshot) in
            
            print("VALUE CHANGED IN MEMBER_PROFILES")
            //setting loggedInUserData
            self.loggedInUserData = snapshot.value as? NSDictionary
            //store the key in the users data variable
            self.loggedInUserData?.setValue(self.loggedInUser!.uid, forKey: "uid")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        //add an observer for the org that is being viewed
        //When the followers count is changed, it is updated here!
        databaseRef.child("organizations").child(self.orgProfile?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            let uid = self.orgProfile?["uid"] as! String
            self.orgProfile = snapshot.value as? NSDictionary
            //add the uid to the profile
            self.orgProfile?.setValue(uid, forKey: "uid")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //check if the current org is being added
        //if yes, Enable the add button
        //if no, Enable the delete button
        
        //currently logged in member will check if they added the organization
        databaseRef.child("member_profiles").child(self.loggedInUser!.uid).child(self.orgProfile?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            if(snapshot.exists())
            {
                self.addButton.setTitle("Delete", for: .normal)
                print("You have not added the organization")
                
            }
            else
            {
                self.addButton.setTitle("Add", for: .normal)
                print("You have not added the organization")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.name.text = self.orgProfile?["organization_name"] as? String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapAdd(_ sender: Any) {
        let addedRef = "added/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.orgProfile?["uid"] as! String)
        let memberValue = self.loggedInUserData?["member_profile"] as! String
        let orgValue = self.orgProfile?["organization"] as! String
        if(self.addButton.titleLabel?.text == "Add"){
            print("add org")
            //            let orgValue = self.orgProfile?["organization"] as! String
            //            let memberValue = self.loggedInUserData?["member_profile"] as! String
            
            //set the organization
            
            let memberAddedData = ["organization_name": memberValue]
            let orgAddedData = ["member_profiles": orgValue]
            
            let childUpdates = [addedRef:memberAddedData,
                                addedRef:orgAddedData]
            
            databaseRef.updateChildValues(childUpdates)
            
            print("data updated")
        }
        
        let membersCount:Int?
        
        if(self.orgProfile?["membersCount"] == nil){
            //set the follower count to 1
            membersCount=1
        }
        else{
            membersCount = self.orgProfile?["membersCount"] as! Int + 1
        }
        
        
        
    }
}
