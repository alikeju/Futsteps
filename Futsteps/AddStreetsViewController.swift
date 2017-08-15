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
    
    var dictionary: [String:AnyObject]?
    
    var postDetails: String?
    
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var memberNameTextField: UITextField!
    @IBOutlet weak var numberOfDoorsTextField: UITextField!
    @IBOutlet weak var timeElapsedTextField: UITextField!
    @IBOutlet weak var sideOfStreetSegmentedControl: UISegmentedControl!
    @IBOutlet weak var commentsTextView: UITextView!
    
    var side = ""
    
    var post : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        self.streetNameTextField.text = self.dictionary?["street_name"] as? String
        self.memberNameTextField.text = self.dictionary?["member_name"] as? String
        self.numberOfDoorsTextField.text = self.dictionary?["number_of_doors"] as? String
        self.timeElapsedTextField.text = self.dictionary?["time_elapsed"] as? String
        self.commentsTextView.text = self.dictionary?["comments"] as? String
        
        let myColor = UIColor.black
        commentsTextView.layer.borderColor = myColor.cgColor
        commentsTextView.layer.borderWidth = 1.0
        
        //To make place holder text in the text view
        commentsTextView.text = "Comment(s)"
        commentsTextView.textColor = UIColor.black
        
        commentsTextView.becomeFirstResponder()
        
        commentsTextView.selectedTextRange = commentsTextView.textRange(from: commentsTextView.beginningOfDocument, to: commentsTextView.beginningOfDocument)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commentsTextView.text = ""
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "streets" {
                print("Enter button tapped")
                
                
//                viewController.productsValue = valueTopass
//                print(productValues)
            }
        }
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
        
        
        //previously this: Organization(uid: "", organization: "")
        PostService.create(streetName: streetName!, name: name!, numOfDoors: numOfDoors!, timeElapsed: timeElapsed!, sideOfStreet: side, comments: comments!) { (key) in
            let firUser = Auth.auth().currentUser
            
           // PostListService.create(firUser: firUser!, postRef: key, name: String)
        }
        print("Enter button Tapped")
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
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
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if commentsTextView.textColor == UIColor.lightGray {
                commentsTextView.selectedTextRange = commentsTextView.textRange(from: commentsTextView.beginningOfDocument, to: commentsTextView.beginningOfDocument)
            }
        }
    }
    
}

extension AddStreetsViewController{
    func configureView(){
        applyKeyboardDismisser()
        
       
    }
}


