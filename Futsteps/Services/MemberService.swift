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
    
//    static func create(_ firOrganization: FIRUser, username: String, organization: Organization,  completion: @escaping (Member?)-> Void) {
//    
//        let currentOrg = Organization.current
//        // 2
//        let username = Member(firOrganization, username, organization)
//        // 3
//        let dict = member.dictValue
//        
//        // 4
//        let memberRef = Database.database().reference().child("members").child(currentOrg.uid).childByAutoId()
//        //5
//        memberRef.updateChildValues(dict)
//    }

    static func create(_ firMember: FIRUser, email: String, username: String, password: String, completion: @escaping (Member?)-> Void){
        
        let currentOrg = Organization.current
        let memberAttrs = ["username": username]
        
//        // 1
//        let currentUser = User.current
//        // 2
//        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
//        // 3
//        let dict = post.dictValue
//        
//        // 4
//        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
//        //5
//        postRef.updateChildValues(dict)

        let ref = Database.database().reference().child("members").child(currentOrg.uid).child(firMember.uid).childByAutoId()
        //let memRef = Database.database().reference().child("member").child(currentMember.uid)
        
        

        
        ref.setValue(memberAttrs) { (error, memRef) in
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
        let ref = Database.database().reference().child("organizations").child(uid).child("member").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let member = Member(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(member)
        })
    }
    
    static func deleteMembers(forUID uid: String, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("organization").child(uid).child("member").child(uid)
        let object = [uid : NSNull()]
        ref.updateChildValues(object) { (error, memRef) -> Void in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return success(false)
            }
            return success(true)
        }
        
    }


}


