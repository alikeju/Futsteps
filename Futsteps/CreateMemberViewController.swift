//
//  OrgProfileViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/31/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import UIKit
import Firebase

class CreateViewController: UIViewController {
    
    
    var loggedInOrg : FIRUser?
    var otherOrg:NSDictionary?
    var databaseRef:DatabaseReference!
    var loggedInOrgData:NSDictionary?
    var org:NSDictionary?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        self.databaseRef = Database.database().reference()
        
        databaseRef.child("organizations").child(self.loggedInOrg!.uid).observe(.value, with: { (snapshot) in
            self.loggedInOrgData = snapshot.value as? NSDictionary
            
            self.loggedInOrgData?.setValue(self.loggedInOrg!.uid, forKey: "uid")
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        databaseRef.child("organizations").child(self.otherOrg?["uid"] as! String).observe(.value, with: {(snapshot) in
            
            let uid = self.otherOrg?["uid"] as! String
            self.otherOrg = snapshot.value as? NSDictionary
            self.otherOrg?.setValue(uid, forKey: "uid")
        }) {(error) in
            print(error.localizedDescription)
        }
        
        databaseRef.child("organizations").child(self.loggedInOrg!.uid).child(self.otherOrg?["uid"] as! String).observe(.value, with: {(snapshot) in
            if (snapshot.exists()){
                self.enterButton.setTitle("Delete", for: .normal)
            } else{
                self.enterButton.setTitle("Add", for: .normal)
            }
            
        }) {(error) in
            print(error.localizedDescription)
        }
        
        //self.name.text = self.otherOrg?["name"] as? String
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Back to Login screen!")
            }
        }
    }
    
    @IBAction func enterButtonAction(_ sender: Any) {
        let orgsRef = "Members/\(self.otherOrg?["uid"] as! String)/\(self.loggedInOrgData?["uid"] as! String)"
        
        let members = "Members" + (self.loggedInOrgData?["uid"] as! String) + "/" + (self.otherOrg?["uid"] as! String) + "/" + (self.otherOrg?["uid"] as! String)
        
        if (self.enterButton.titleLabel?.text == "Enter"){
            
            let orgData = ["name":self.loggedInOrgData?["name"] as! String]
            
            //The member name and profile pic.
            let memberData = ["name":self.otherOrg?["name"] as! String]
            
            let childUpdates = [orgsRef:orgData,
                                members:memberData]
            
            databaseRef.updateChildValues(childUpdates)
            
            guard let email = emailTextField.text,
                let username = usernameTextField.text,
                let password = passwordTextField.text,
                !email.isEmpty,
                !username.isEmpty,
                !password.isEmpty
                
                else{
                    print("Please fill all fields!")
                    return
            }
            
            AuthService.createUser(controller: self, email: email, password: password) { (authUser) in
                guard let firMember = authUser
                    else {
                        return
                }
                
                
                MemberService.create(firMember, email: email, username: username, password: password) { (member) in
                    guard let member = member else {
                        return
                    }
                    
                    Member.setCurrent(member, writeToUserDefaults: true)
                    
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
            
        }
    }
}

extension CreateViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
}
