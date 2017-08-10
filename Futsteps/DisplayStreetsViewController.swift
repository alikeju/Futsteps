//
//  DisplayStreetsViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/9/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit

class DisplayStreetsViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

extension DisplayStreetsViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
}
