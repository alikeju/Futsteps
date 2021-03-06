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
    static func create(firMember: FIRUser, email: String, username: String, password: String, completion: @escaping (Member?)-> Void){
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

    
    static func posts(for member: Member, completion: @escaping ([Post]) -> Void){
        let ref = Database.database().reference().child("user_posts").child(member.uid)
        
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let deposits = snapshot.reversed().flatMap(Post.init)
            completion(deposits)
        })
    }
    
    static func timeline(completion: @escaping ([Post]) -> Void) {
        let currentUser = Member.current

        let timelineRef = Database.database().reference().child("org_posts").child(currentUser.org_uid!)
        timelineRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let dispatchGroup = DispatchGroup()
            
            var posts = [Post]()
   
            for postSnap in snapshot {
                dispatchGroup.enter()
                
                PostService.show(forKey: postSnap.key, posterUID: postSnap.key) { (post) in
                    if let post = post {
                        posts.append(post)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts.reversed())
            })
        })
    }
    
    static func deleteUser(forUID uid: String, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("member_profiles")
        let object = [uid : NSNull()]
        ref.updateChildValues(object) { (error, ref) -> Void in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return success(false)
            }
            return success(true)
        }
    }
}

