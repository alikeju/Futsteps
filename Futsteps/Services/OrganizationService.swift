//  OrganizationService.swift
//  Futsteps
//  Created by Alikeju Adejo on 7/25/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct OrganizationService {
    static func createOrg(_ firOrganization: FIRUser, username: String, organization_name: String, member_uid: String, completion: @escaping (Organization?)-> Void){
   
        
        let orgAttrs = ["organization_name": organization_name,
                        "member_uid": Member.current.uid]
        
        let ref = Database.database().reference().child("organizations").child(firOrganization.uid)
        ref.setValue(orgAttrs) { (error, ref) in
            if let error = error{
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let org = Organization(snapshot: snapshot)
                completion(org)
            })
            
        }
    }
    
    
    
    static func show(forUID uid: String, completion: @escaping (Organization?) -> Void) {
        let ref = Database.database().reference().child("organizations").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let organization = Organization(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(organization)
        })
    }
    
    static func deleteOrganization(forUID uid: String, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("organizations")
        let object = [uid : NSNull()]
        ref.updateChildValues(object) { (error, ref) -> Void in
            if let error = error {
                print("error : \(error.localizedDescription)")
                return success(false)
            }
            return success(true)
        }
        
    }
    
    
    
    static func timeline(completion: @escaping ([Post]) -> Void) {
        
        let timelineRef = Database.database().reference().child("org_posts").child(Member.current.uid)
        timelineRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            let dispatchGroup = DispatchGroup()
            
            var posts = [Post]()
            //posts is nil
            for postSnap in snapshot {
                dispatchGroup.enter()
                
                PostService.orgShow(forKey: postSnap.key, posterUID: postSnap.key) { (post) in
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
}

