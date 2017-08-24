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

class AddStreetsViewController: UIViewController, UITextViewDelegate{
    
    var dictionary: [String:AnyObject]?
    
    var activeField: UITextField?
    
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var memberNameTextField: UITextField!
    @IBOutlet weak var numberOfDoorsTextField: UITextField!
    @IBOutlet weak var timeElapsedTextField: UITextField!
    @IBOutlet weak var sideOfStreetSegmentedControl: UISegmentedControl!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var enterButton: UIButton!
    
    var side = ""
    
    var post : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        registerForKeyboardNotifications()
        
        self.commentsTextView.delegate = self
        
        if let post = self.post {
            self.commentsTextView.text = post.comments
            self.streetNameTextField.text = post.streetname
            self.memberNameTextField.text = post.name
            self.numberOfDoorsTextField.text = post.numOfDoors
            self.timeElapsedTextField.text = post.timeElapsed
        } else {
            let myColor = UIColor.black
            commentsTextView.layer.borderColor = myColor.cgColor
            commentsTextView.layer.borderWidth = 1.0
            
            //To make place holder text in the text view
            commentsTextView.text = "Comment(s)"
            commentsTextView.textColor = UIColor.lightGray
            
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        if post != nil{
            
            if Member.current.uid != post!.memberUID {
                
                streetNameTextField.isUserInteractionEnabled = false
                memberNameTextField.isUserInteractionEnabled = false
                numberOfDoorsTextField.isUserInteractionEnabled = false
                timeElapsedTextField.isUserInteractionEnabled = false
                commentsTextView.isUserInteractionEnabled = false
                sideOfStreetSegmentedControl.isUserInteractionEnabled = false
                enterButton.setTitle("Done", for: UIControlState.normal)
                
                disablesAutomaticKeyboardDismissal = false
                view.addGestureRecognizer(tap)
            } else {
                disablesAutomaticKeyboardDismissal = true
            }
            
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // commentsTextView.text = ""
        
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
            let comments = commentsTextView.text,
            !streetName.isEmpty,
            !name.isEmpty,
            !numOfDoors.isEmpty,
            !timeElapsed.isEmpty,
            !comments.isEmpty
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
        
        //OBSERVE LINE!!
        PostService.create(streetName: streetName, name: name, numOfDoors: numOfDoors, timeElapsed: timeElapsed, sideOfStreet: side, comments: comments, memberUID: Member.current.uid) { (key) in

        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != UIColor.black {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comment(s)"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        
        let currentText = textView.text as NSString?
        
        let updatedText = currentText?.replacingCharacters(in: range, with: text)
        //let updatedText = currentText?.replacingCharacters(in: range as Range, with: text)
        
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if (updatedText?.isEmpty)! {
            
            commentsTextView.text = "Comment(s)"
            commentsTextView.textColor = UIColor.lightGray
            
            commentsTextView.selectedTextRange = commentsTextView.textRange(from: commentsTextView.beginningOfDocument, to: commentsTextView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if commentsTextView.textColor == UIColor.lightGray && !text.isEmpty {
            commentsTextView.text = nil
            commentsTextView.textColor = UIColor.black
        }
        
        return true
    }
    
    //----------------------------------------------------------------------------------------------------
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.commentsTextView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.commentsTextView.contentInset = contentInsets
        self.commentsTextView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.commentsTextView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.commentsTextView.contentInset = contentInsets
        self.commentsTextView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.commentsTextView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
}

extension AddStreetsViewController{
    func configureView(){
        applyKeyboardDismisser()
    }
}


