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
        
     //   let currentUID = Member.current.uid
        
        let postAttrs = ["street_name": streetName,
                         "name" : name,
                         "numDoors" : numOfDoors,
                         "timeElapsed" : ServerValue.timestamp(),
                         "sideOfStreet": sideOfStreet,
                         "comments": comments] as [String : Any]
        
        
//        
//        let currentUID = Member.current.uid
//        
//        let addData = ["member_profiles/\(currentUID)/organization_name" : org.organization,
//                       "organizations_of_members/\(org.uid)/\(currentUID)/member" : "true"]
//        
//        let ref = Database.database().reference()
//        ref.updateChildValues(addData) { (error, _) in
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//            }
//            
//            // 3
//            success(error == nil)
//        }
        
        let ref = Database.database().reference().child("posts").childByAutoId()
        ref.setValue(postAttrs) { (error, ref)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        return completion(ref.key)
    }
    
}


    
