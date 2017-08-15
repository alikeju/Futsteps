//
//  PostService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/10/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth.FIRUser

class PostService{

    static func create(streetName: String, name: String, numOfDoors: String, timeElapsed: String, sideOfStreet: String, comments: String, completion: @escaping(String) -> Void){
        
        let member = Member.current.username
       // let org_member = Member.
        
        let postAttrs = ["street_name": streetName,
                         "name" : member,
                         "numDoors" : numOfDoors,
                         "timeElapsed" : ServerValue.timestamp(),
                         "sideOfStreet": sideOfStreet,
                         "comments": comments] as [String : Any]

        // let ref = Database.database().reference().child("posts").childByAutoId()
        
        var ref:DatabaseReference? = nil
        
        // DatabaseReference()
        
        //you want a variable that stores the key of the post
        ref = Database.database().reference().child("user_posts").child(Member.current.uid).childByAutoId()
        let currentKey = ref?.key
        ref?.setValue(postAttrs) { (error, ref)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    
       // let ref2 = Database.database().reference().child("org_posts").child(currentKey!)
        
        let ref2 = Database.database().reference().child("org_posts").child(Member.current.org_uid!).child(currentKey!)
        
        ref2.setValue(postAttrs) { (error, ref2)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        return completion(ref!.key)
    }
    
}



