//
//  HomeViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/12/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeViewController: UIViewController{
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        //AuthService.presentLogOut(viewController: self)
        
        let initialViewController = UIStoryboard.initialViewController(for: .login)
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        AuthService.removeAuthListener(authHandle: authHandle)
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        guard let user = Auth.auth().currentUser else {
            return
        }
        AuthService.presentDelete(viewController: self, user : user, success: { success in
            if success! {
                let initialViewController = UIStoryboard.initialViewController(for: .login)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                
            }
            
        })
    }
    
}
