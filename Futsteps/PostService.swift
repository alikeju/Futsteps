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
        let postAttrs = ["street_name": streetName,
                         "name" : name,
                         "numDoors" : numOfDoors,
                         "timeElapsed" : ServerValue.timestamp(),
                         "sideOfStreet": sideOfStreet,
                         "comments": comments] as [String : Any]
        
        let ref = Database.database().reference().child("posts").childByAutoId()
        ref.setValue(postAttrs) { (error, ref)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        return completion(ref.key)
    }
    
}


    
