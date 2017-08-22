//
//  OrganizationLoginViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/25/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class OrganizationLoginViewController: UIViewController{
    //var initialViewController: UIViewController
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func enterButton(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else{
                return
        }
        AuthService.signIn(controller: self, email: email, password: password) { (org) in
            guard let org = org else {
                print("error: FIRUser does not exist!")
                return
            }
            
            OrganizationService.show(forUID: org.uid) { (org) in
                if let org = org {
                    Organization.setCurrent(org, writeToUserDefaults: true)
                    
                    let storyboard = UIStoryboard(name: "OrgMain", bundle: .main)
                    let initialViewController = storyboard.instantiateInitialViewController()!

                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
                else {
                    print("error: User does not exist!")
                    return
                }
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                print("Organization was logged in.")
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}

extension OrganizationLoginViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
}
