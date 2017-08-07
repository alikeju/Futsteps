//
//  MemberService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/26/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct MemberService{
    static func create(_ firMember: FIRUser, email: String, username: String, password: String, completion: @escaping (Member?)-> Void){
        let memberAttrs = ["username": username]
        
        let ref = Database.database().reference().child("member_profiles").child(firMember.uid)
        
        ref.setValue(memberAttrs) { (error, ref) in
            if let error = error{
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let member = Member(snapshot: snapshot)
                completion(member)
            })
            
        }
    }
    
    static func show(forUID uid: String, completion: @escaping (Member?) -> Void) {
        let ref = Database.database().reference().child("member_profiles").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let member = Member(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(member)
        })
    }
    
    //make a add organization method
    
}


