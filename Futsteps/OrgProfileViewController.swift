//
//  OrgProfileViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/7/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import UIKit
import Firebase
//: Telling the type
//= Assigning the value

protocol OrgProfileViewDelegate: class {
    func didTapAdd()
}

class OrgProfileViewController: UIViewController {
    
    weak var delegate: OrgProfileViewDelegate?

    var organizations = [Organization]()
    
    //Create an instance of an org with the profile that I got. From that org use the isAdded function.
    var loggedInUser:FIRUser?
    var orgProfile:NSDictionary?
    var orgProfile1: Organization?
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
        
            //creating instance of org
            //self.orgProfile1 = Organization(snapshot: snapshot)
            
            //store the key in the users data variable
            self.loggedInUserData?.setValue(self.loggedInUser!.uid, forKey: "uid")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        

        
        //add an observer for the org that is being viewed
        //When the followers count is changed, it is updated here!
        //changed orgProfile to orgProfile1
        
        databaseRef.child("organizations").child(self.orgProfile?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            let uid = self.orgProfile?["uid"] as! String
            let organization = self.orgProfile?["organization_name"] as! String
            
            self.orgProfile = snapshot.value as? NSDictionary
            
            self.orgProfile1 = Organization(snapshot: snapshot)
            //Put snapshot in
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
        addButton.isUserInteractionEnabled = false
        let addee = orgProfile1!
        //^^LINE FOUND TO BE NIL
        
        AddService.setIsAdded(!addee.isAdded, fromCurrentUserTo: addee) { (success) in
            defer {
                self.addButton.isUserInteractionEnabled = true
            }
            
            guard success else { return }
            
            addee.isAdded = !addee.isAdded
            
            
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            print("Organization was added.")
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
        }
    }
}



