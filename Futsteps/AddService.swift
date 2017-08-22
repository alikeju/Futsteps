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
        
        Member.setCurrent(Member(uid: Member.current.uid, username: Member.current.username, organization_name: org.organization, org_uid: org.uid))
        
        
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
}
