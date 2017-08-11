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

//post Struct was here moved to different location.

class AddStreetsViewController: UIViewController{
    
    
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var memberNameTextField: UITextField!
    @IBOutlet weak var numberOfDoorsTextField: UITextField!
    @IBOutlet weak var timeElapsedTextField: UITextField!
    @IBOutlet weak var sideOfStreetSegmentedControl: UISegmentedControl!
    @IBOutlet weak var commentsTextView: UITextView!
    
    var side = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let myColor = UIColor.black
        commentsTextView.layer.borderColor = myColor.cgColor
        commentsTextView.layer.borderWidth = 1.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commentsTextView.text = ""
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    @IBAction func enterButtonTapped(_ sender: Any) {
        let streetName = streetNameTextField.text
        let name = memberNameTextField.text
        let numOfDoors = numberOfDoorsTextField.text
        let timeElapsed = timeElapsedTextField.text
        let comments = commentsTextView.text
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
        PostService.create(streetName: streetName!, name: name!, numOfDoors: numOfDoors!, timeElapsed: timeElapsed!, sideOfStreet: side, comments: comments!) { (key) in
            let firUser = Auth.auth().currentUser
            PostListService.create(firUser: firUser!, postRef: key)
        }
        print("Enter button Tapped")
        
    }
}

extension AddStreetsViewController{
    func configureView(){
        applyKeyboardDismisser()
        
       
    }
}


