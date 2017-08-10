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
    
    @IBOutlet weak var memberNameTextField: UITextField!
    @IBOutlet weak var numberOfDoorsTextField: UITextField!
    @IBOutlet weak var timeElapsedTextField: UITextField!
    @IBOutlet weak var sideOfStreetSegmentedControl: UISegmentedControl!
    
    var side = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "cancel" {
                print("Cancel button tapped")
            } else if identifier == "save" {
                print("Save button tapped")
                
                // 1
                let street = Street()
                
                street.memberName = memberNameTextField.text ?? ""
                street.numberOfDoors = numberOfDoorsTextField.text ?? ""
                street.timeElapsed = timeElapsedTextField.text ?? ""
                switch sideOfStreetSegmentedControl.selectedSegmentIndex{
                case 0:
                    side = "Odd"
                case 1:
                    side = "Even"
                case 2:
                    side = "Both"
                default:
                    break
                }
                street.modificationTime = Date()
            }
        }
    }
}

extension DisplayStreetsViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
}

