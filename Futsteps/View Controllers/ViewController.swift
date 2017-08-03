//
//  ViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/24/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
          dismiss(animated: true, completion: nil)
          performSegue(withIdentifier: "unwindToChooserUser", sender: self)
    }
    
    
//    @IBAction func backButtonAction(_ sender: Any) {
//        //dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: "unwindSegueToChooseUser", sender: self)
//    }
    
 
}

