//
//  DisplayStreetsViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/9/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class AddStreetsViewController: UIViewController, UITextViewDelegate{
    
    var dictionary: [String:AnyObject]?

    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var memberNameTextField: UITextField!
    @IBOutlet weak var numberOfDoorsTextField: UITextField!
    @IBOutlet weak var timeElapsedTextField: UITextField!
    @IBOutlet weak var sideOfStreetSegmentedControl: UISegmentedControl!
    @IBOutlet weak var enterButton: UIButton!
    
    var side = ""
    
    var post : Post?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        if let post = self.post {
            self.streetNameTextField.text = post.streetname
            self.memberNameTextField.text = post.name
            self.numberOfDoorsTextField.text = post.numOfDoors
            self.timeElapsedTextField.text = post.timeElapsed
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        if post != nil{
            
            if Member.current.uid != post!.memberUID {
                
                streetNameTextField.isUserInteractionEnabled = false
                memberNameTextField.isUserInteractionEnabled = false
                numberOfDoorsTextField.isUserInteractionEnabled = false
                timeElapsedTextField.isUserInteractionEnabled = false
            //    commentsTextView.isUserInteractionEnabled = false
                sideOfStreetSegmentedControl.isUserInteractionEnabled = false
                enterButton.setTitle("Done", for: UIControlState.normal)
                
//                disablesAutomaticKeyboardDismissal = false
                
                view.addGestureRecognizer(tap)
            } else {
//                disablesAutomaticKeyboardDismissal = true
            }
            
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        if post != nil && Member.current.uid != post!.memberUID {
            return
        }
        
        guard let streetName = streetNameTextField.text,
            let name = memberNameTextField.text,
            let numOfDoors = numberOfDoorsTextField.text,
            let timeElapsed = timeElapsedTextField.text,
           // let comments = commentsTextView.text,
            !streetName.isEmpty,
            !name.isEmpty,
            !numOfDoors.isEmpty,
            !timeElapsed.isEmpty

            else {
                enterButton.isUserInteractionEnabled = false
                return
        }
        
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
        
        PostService.create(streetName: streetName, name: name, numOfDoors: numOfDoors, timeElapsed: timeElapsed, sideOfStreet: side, memberUID: Member.current.uid) { (key) in
            
        }
        
    }
    
}

extension AddStreetsViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
}


