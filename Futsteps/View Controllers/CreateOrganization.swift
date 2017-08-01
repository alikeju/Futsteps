//
//  CreateOrganization.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/27/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit

class CreateOrganization: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var organizationNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" { 
                print("Back to Login screen!")
            }
        }
    }
    
    @IBAction func enterButton(_ sender: Any) {
        guard let email = emailTextField.text,
            let organization = organizationNameTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !organization.isEmpty,
            !password.isEmpty
            
            else {
                print("Please fill all fields!")
                return
        }
        
        print(self)
        
        AuthService.createUser(controller: self, email: email, password: password) { (authOrg) in
            guard let firOrg = authOrg else {
                return
            }
            
            OrganizationService.create(firOrg, email: email, organization_name: organization, password: password) { (user) in
                guard let user = user else {
                    return
                }
                
                Organization.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                
                
            }
        }
    }
}

extension CreateOrganization{
    func configureView(){
        applyKeyboardDismisser()
    }
}
