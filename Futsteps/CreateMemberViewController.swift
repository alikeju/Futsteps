//
//  OrgProfileViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/31/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import UIKit
import Firebase


class CreateMemberViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    var loggedInUser:AnyObject?
    var databaseRef = Database.database().reference()
    var loggedInUserData:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedInUser = Auth.auth().currentUser
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "findOrgsSegue"){
                let showFindOrgsTableViewController = segue.destination as! FindOrgsTableViewController
                
                showFindOrgsTableViewController.loggedInUser = self.loggedInUser as? FIRUser
            }
        }
    
    
    @IBAction func enterButton(_ sender: Any) {
    
        guard let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !username.isEmpty,
            !password.isEmpty
            
            else {
                print("Please fill all fields!")
                return
        }
        
        print(self)
        //
        AuthService.createUser(controller: self, email: email, password: password) { (authOrg) in
            guard let firOrg = authOrg else {
                return
            }
            
            MemberService.create(firOrg, email: email, username: username, password: password) { (member) in
                guard let member = member else {
                    return
                }
                
                Member.setCurrent(member, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                print("Member was created.")
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            
            }
        }
    }
}

extension CreateMemberViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
}
