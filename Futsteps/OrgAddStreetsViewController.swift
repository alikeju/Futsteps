//
//  OrgAddStreetsViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/21/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

//post Struct was here moved to different location.

class OrgAddStreetsViewController: UIViewController{
    
    var dictionary: [String:AnyObject]?
    
    var postDetails: [String: Any]?
    
    
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var memberNameTextField: UITextField!
    
    @IBOutlet weak var numberOfDoorsTextField: UITextField!
    
    @IBOutlet weak var sideOfStreetSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timeElapsedTextField: UITextField!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var enterButton: UIButton!
    
    var side = ""
    
    var post : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        self.streetNameTextField.text = post?.streetname
        self.memberNameTextField.text = post?.name
        self.numberOfDoorsTextField.text = post?.numOfDoors
        self.commentsTextView.text = post?.comments
        self.timeElapsedTextField.text = post?.timeElapsed
        
        
        streetNameTextField.isUserInteractionEnabled = false
        enterButton.isUserInteractionEnabled = false
        memberNameTextField.isUserInteractionEnabled = false
        numberOfDoorsTextField.isUserInteractionEnabled = false
        timeElapsedTextField.isUserInteractionEnabled = false
        sideOfStreetSegmentedControl.isUserInteractionEnabled = false
        commentsTextView.isUserInteractionEnabled = false
        view.addGestureRecognizer(tap)
        disablesAutomaticKeyboardDismissal = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // commentsTextView.text = ""
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
