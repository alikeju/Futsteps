//
//  OrganizationService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/25/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct OrganizationService {
    static func create(_ firOrganization: FIRUser, email: String, organization: String, password: String, completion: @escaping (Organization?)-> Void){
        let orgAttrs = ["organization": organization]
        
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
    
    static func members(for user: User, completion: @escaping ([Member]) -> Void) {
        let ref = Database.database().reference().child("members").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            let members = snapshot.reversed().flatMap(Member.init)
            completion(members)
        })
    }
    
    static func deleteOrganization(forUID uid: String, success: @escaping (Bool) -> Void) {
        let ref = Database.database().reference().child("members")
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

