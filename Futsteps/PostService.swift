//
//  PostService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/10/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth.FIRUser

class PostService{
    
    static func create(streetName: String, name: String, numOfDoors: String, timeElapsed: String, sideOfStreet: String, comments: String, completion: @escaping(String) -> Void){
       
        let currentMember = Member.current
        
        let post = Post(streetname: streetName, name: name, numOfDoors: numOfDoors, timeElapsed: timeElapsed, sideOfStreet: sideOfStreet, comments: comments)
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("org_posts").child(currentMember.org_uid!).childByAutoId()
        
        newPostRef.updateChildValues(post.dictValue)

  
    }
    
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        let currentMember = Member.current

        let newPostRef = Database.database().reference().child("org_posts").child(currentMember.org_uid!).child(postKey)
        newPostRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let post = Post(snapshot: snapshot)
                else { return completion(nil) }
            completion(post)
        })
    }
    

    static func orgShow(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        
        let newPostRef = Database.database().reference().child("org_posts").child(Organization.current.uid).child(postKey)
        newPostRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let post = Post(snapshot: snapshot)
                else { return completion(nil) }
            completion(post)
        })
    }
    
}


