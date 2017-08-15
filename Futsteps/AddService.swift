//
//  AddService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/7/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct AddService {
    private static func addOrg(_ org: Organization, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = Member.current.uid
        
        let addData = ["member_profiles/\(currentUID)/organization_name" : org.organization,
                       "member_profiles/\(currentUID)/org_uid" : org.uid,
                       "organizations_of_members/\(org.uid)/\(currentUID)/member" : "true"]
        
        let ref = Database.database().reference()
        ref.updateChildValues(addData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // 3
            success(error == nil)
        }
    }
    
    static func setIsAdded(_ isAdded: Bool, fromCurrentUserTo addee: Organization, success: @escaping (Bool) -> Void) {
        if isAdded {
            addOrg(addee, forCurrentUserWithSuccess: success)
        }
    }
    
//    static func isOrgAdded(_ org: Organization, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
//        let currentUID = Member.current.uid
//        let ref = Database.database().reference().child("members").child(org.uid)
//        
//        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? [String : Bool] {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        })
//    }
}
