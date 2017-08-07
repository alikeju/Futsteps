//
//  OrganizationService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/25/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct OrganizationService {
    static func create(_ firOrganization: FIRUser, email: String, organization_name: String, password: String, completion: @escaping (Organization?)-> Void){
        let orgAttrs = ["organization_name": organization_name]
        
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
    //make add member method 
    
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
    
    static func orgsExcludingCurrentOrg(completion: @escaping ([Organization]) -> Void) {
        let currentUser = Member.current
        // 1
        let ref = Database.database().reference().child("organizations")
        
        // 2
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            // 3
            let orgs =
                snapshot
                    .flatMap(Organization.init)
                    .filter { $0.uid != currentUser.uid }
            
            // 4
            let dispatchGroup = DispatchGroup()
            orgs.forEach { (org) in
                dispatchGroup.enter()
                
                // 5
                AddService.isOrgAdded(org) { (isAdded) in
                    org.isAdded = isAdded
                    dispatchGroup.leave()
                }
            }
            
            // 6
            dispatchGroup.notify(queue: .main, execute: {
                completion(orgs)
            })
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

