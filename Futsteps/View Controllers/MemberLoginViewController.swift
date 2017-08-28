  //
//  LoginViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/24/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit

class MemberLoginViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showActivityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    

    @IBAction func enterButton(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text
            else{
            return
        }
        
        enterButton.isUserInteractionEnabled = false
        self.showActivityIndicator()
        self.indicator.startAnimating()
        self.indicator.backgroundColor = UIColor.white
        
        AuthService.signIn(controller: self, email: email, password: password) { (member) in
            guard let member = member else {
                print("error: FIRUser does not exist!")
                return
            }
            
            MemberService.show(forUID: member.uid) { (member) in
                if let member = member {
                    Member.setCurrent(member, writeToUserDefaults: true)
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
                else {
                    print("error: User does not exist!")
                    return
                }
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
}

extension MemberLoginViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
}
