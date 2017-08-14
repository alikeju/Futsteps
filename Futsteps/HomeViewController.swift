//
//  HomeViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/12/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController{
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
       // AuthService.presentLogOut(viewController: self)
        
        let initialViewController = UIStoryboard.initialViewController(for: .login)
        print("Member was logged out.")
        self.view.window?.rootViewController = initialViewController
        self.view.window?.makeKeyAndVisible()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
