//
//  AuthService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/26/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//


import UIKit
import FirebaseAuth

struct AuthService {
    // Signs in as an authenticated user on Firebase
    static func signIn(controller : UIViewController, email: String, password: String, completion: @escaping (FIRUser?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                loginErrors(error: error, controller: controller)
                return completion(nil)
            }
            return completion(user)
        }
    }
    
    static func createUser(controller : UIViewController, email: String, password: String, completion: @escaping (FIRUser?) -> Void){
    
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                signUpErrors(error: error, controller: controller)
                return completion(nil)
            }
            
            return completion(Auth.auth().currentUser)
        }
    }
    
    static func createOrg(controller : UIViewController, organization_name: String, accessCode: String,  completion: @escaping (FIRUser?) -> Void){
        
        Auth.auth().createUser(withEmail: organization_name, password: accessCode) { (user, error) in
            if let error = error {
                accessCodeErrors(error: error, controller: controller)
                return completion(nil)
            }
            
            return completion(Auth.auth().currentUser)
        }
    }
    static func passwordReset(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("email error for: \(email)")
                print("error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    static func presentLogOut(viewController : UIViewController){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Log Out", style: .destructive) { _ in
            logUserOut()
        }
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    static func logUserOut(){
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            assertionFailure("Error signing out: \(error.localizedDescription)")
        }
    }
    
    static func presentDelete(viewController : UIViewController, user : FIRUser, success: @escaping (Bool?) -> Void ){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Delete Account", style: .destructive) { _ in
            deleteAccount(user: user)
            success(true)
        }
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    static func presentDeleteOrg(viewController : UIViewController, user : FIRUser, success: @escaping (Bool?) -> Void ){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Delete Account", style: .destructive) { _ in
            deleteOrgAccount(user: user)
            success(true)
        }
        
        alertController.addAction(signOutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    static func removeAuthListener(authHandle : AuthStateDidChangeListenerHandle?){
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
    }
    
    static func deleteAccount(user : FIRUser){
        MemberService.deleteUser(forUID: Member.current.uid, success: { (success) in
            if success {
                logUserOut()
                
                user.delete { error in
                    if let error = error {
                        print("DELETE ERROR \(error.localizedDescription)")
                    }
                }
            }
        })
    }
    
    static func deleteOrgAccount(user : FIRUser){
        OrganizationService.deleteOrganization(forUID: (Member.current.uid), success: { (success) in
            if success {
                logUserOut()
                
                user.delete { error in
                    if let error = error {
                        print("DELETE ERROR \(error.localizedDescription)")
                    }
                }
            }
        })
    }
    private static func loginErrors(error : Error, controller : UIViewController){
        print(error.localizedDescription)
        switch (error.localizedDescription) {
        case "The email address is badly formatted.":
            let invalidEmailAlert = UIAlertController(title: "Invalid Email", message:
                "It seems like you have put in an invalid email.", preferredStyle: UIAlertControllerStyle.alert)
            invalidEmailAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(invalidEmailAlert, animated: true, completion: nil)
            break;
        case "The password is invalid or the user does not have a password.":
            let wrongPasswordAlert = UIAlertController(title: "Wrong Password", message:
                "It seems like you have entered the wrong password.", preferredStyle: UIAlertControllerStyle.alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(wrongPasswordAlert, animated: true, completion: nil)
            break;
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            let wrongPasswordAlert = UIAlertController(title: "No Account Found", message:
                "We couldn't find an account that corresponds to that email. Do you want to create an account?", preferredStyle: UIAlertControllerStyle.alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(wrongPasswordAlert, animated: true, completion: nil)
            break;
        case "The email address is already in use by another account.":
            let wrongPasswordAlert = UIAlertController(title: "Email Address is Already in Use.", message:
                "It seems like this email address is already in use. Would you like to try another one?", preferredStyle: UIAlertControllerStyle.alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(wrongPasswordAlert, animated: true, completion: nil)
            break;
        default:
            let loginFailedAlert = UIAlertController(title: "Error Logging In", message:
                "There was an error logging you in. Please try again soon.", preferredStyle: UIAlertControllerStyle.alert)
            loginFailedAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(loginFailedAlert, animated: true, completion: nil)
            break;
        }
    }
    
    private static func signUpErrors(error: Error, controller: UIViewController) {
        print(error.localizedDescription)
        switch(error.localizedDescription) {
        case "The email address is badly formatted.":
            let invalidEmail = UIAlertController(title: "Email is not properly formatted.", message:
                "Please enter a valid email to sign up with..", preferredStyle: UIAlertControllerStyle.alert)
            invalidEmail.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(invalidEmail, animated: true, completion: nil)
            break;
        case "The password must be 6 characters long or more.":
            let invalidEmail = UIAlertController(title: "Password is not strong enough.", message:
                "Please enter a stronger password.", preferredStyle: UIAlertControllerStyle.alert)
            invalidEmail.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(invalidEmail, animated: true, completion: nil)
            break;
        case "The email address is already in use by another account.":
            let wrongPasswordAlert = UIAlertController(title: "Email Address is Already in Use.", message:
                "It seems like this email address is already in use. Would you like to try another one?", preferredStyle: UIAlertControllerStyle.alert)
            wrongPasswordAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(wrongPasswordAlert, animated: true, completion: nil)
            break;
        default:
            let generalErrorAlert = UIAlertController(title: "We are having trouble signing you up.", message:
                "We are having trouble signing you up, please try again soon.", preferredStyle: UIAlertControllerStyle.alert)
            generalErrorAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(generalErrorAlert, animated: true, completion: nil)
            break;
        }
    }
    
    private static func accessCodeErrors(error: Error, controller: UIViewController) {
        switch(error.localizedDescription) {
        case "The password must be 6 characters long or more.":
        let invalidEmail = UIAlertController(title: "Access Code is not strong enough.", message:
            "Please enter a stronger access code.", preferredStyle: UIAlertControllerStyle.alert)
        invalidEmail.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
        controller.present(invalidEmail, animated: true, completion: nil)
        break;
        
        default:
        let generalErrorAlert = UIAlertController(title: "We are having trouble signing you up.", message:
            "We are having trouble signing you up, please try again soon.", preferredStyle: UIAlertControllerStyle.alert)
        generalErrorAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
        controller.present(generalErrorAlert, animated: true, completion: nil)
        break;
        }
    }
    
    private static func invalidFieldsErrors(error: Error, controller: UIViewController) {
        switch(error.localizedDescription) {
        case "Invalid amount of fields filled.":
            let invalidEmail = UIAlertController(title: "Please fill all fields.", message:
                "Please fill all fields.", preferredStyle: UIAlertControllerStyle.alert)
            invalidEmail.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(invalidEmail, animated: true, completion: nil)
            break;
        default:
            let generalErrorAlert = UIAlertController(title: "Please fill all fields.", message:
                "Please fill all fields.", preferredStyle: UIAlertControllerStyle.alert)
            generalErrorAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            controller.present(generalErrorAlert, animated: true, completion: nil)
            break;
        }
    }
    
    
}
