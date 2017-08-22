//
//  OrgHomeViewcontroller.swift
//  
//
//  Created by Alikeju Adejo on 8/21/17.
//
//

import Foundation
import UIKit
import FirebaseAuth

class OrgHomeViewController: UIViewController{
    
    var authHandle: AuthStateDidChangeListenerHandle?
    
//    @IBAction func logOutButtonTapped(_ sender: UIButton) {
//        //AuthService.presentLogOut(viewController: self)
//        
//        let initialViewController = UIStoryboard.initialViewController(for: .login)
//        print("Member was logged out.")
//        self.view.window?.rootViewController = initialViewController
//        self.view.window?.makeKeyAndVisible()
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        AuthService.removeAuthListener(authHandle: authHandle)
    }
    
//    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
//        guard let user = Auth.auth().currentUser else {
//            print("NO USER EXISTS???")
//            return
//        }
    
    
//        AuthService.presentDelete(viewController: self, user : user, success: { success in
//            if success! {
//                let initialViewController = UIStoryboard.initialViewController(for: .login)
//                print("Member deleted their account.")
//                self.view.window?.rootViewController = initialViewController
//                self.view.window?.makeKeyAndVisible()
//            } else {
//                print("No bueno. User cancelled.")
//            }
//            
//        })
//    }
    
}
