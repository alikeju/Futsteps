//
//  CreateMemberViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/27/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.


import Foundation
import UIKit
import FirebaseAuth.FIRUser

class CreateMemberViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
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
    
    @IBAction func enterButtonAction(_ sender: Any) {
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
        
        self.performSegue(withIdentifier: Constants.Segue.toSearchOrg, sender: self)
        
        
    }
}


extension CreateMemberViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
    
}
