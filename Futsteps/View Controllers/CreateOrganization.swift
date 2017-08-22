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
    
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var organizationNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
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
    
    func showActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
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
        
        enterButton.isUserInteractionEnabled = false
        self.showActivityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        
        print(self)
        
        AuthService.createUser(controller: self, email: email, password: password) { (authOrg) in
            guard let firOrg = authOrg else {
                return
            }
            
            OrganizationService.createOrg(firOrg, email: email, organization_name: organization, password: password) { (user) in
                guard let user = user else {
                    return
                }
                
                Organization.setCurrent(user, writeToUserDefaults: true)
                
                let storyboard = UIStoryboard(name: "OrgMain", bundle: .main)
                let initialViewController = storyboard.instantiateInitialViewController()!
                
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
            
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }
    }
}


extension CreateOrganization{
    func configureView(){
        applyKeyboardDismisser()
    }
}
