//
//  PostListService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/10/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PostListService{
    static func create(firUser: FIRUser, postRef: String){
        
        let ref = Database.database().reference().child("posts").child(firUser.uid).childByAutoId()
        ref.setValue(postRef) { (error, ref)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
