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
    
    
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    var loggedInUser:AnyObject?
    var databaseRef = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func showActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
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
        enterButton.isUserInteractionEnabled = false
        self.showActivityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        
        print(self)
    
        AuthService.createUser(controller: self, email: email, password: password) { (authMember) in
            guard let firMember = authMember else {
                return
            }
            
            MemberService.create(firMember: firMember, email: email, username: username, password: password) { (member) in
                guard let member = member else {
                    return
                }
                
                Member.setCurrent(member, writeToUserDefaults: true)
                
                self.loggedInUser = Auth.auth().currentUser
                
                self.performSegue(withIdentifier: "findOrgsSegue", sender: self)
                
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            }
        }
    }
    
 }
 
 extension CreateMemberViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
 }
