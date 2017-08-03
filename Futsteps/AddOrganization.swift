//
//  AddOrganization.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/3/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct AddOrganization {
    private static func addOrg(_ org: Organization, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        // 1
        let currentUID = Member.current.uid
        let addData = ["myOrgs/\(org.uid)/\(currentUID)" : true,
                          "addedOrgs/\(currentUID)/\(org.uid)" : true]
        
        // 2
        let ref = Database.database().reference()
        ref.updateChildValues(addData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            // 3
            success(error == nil)
        }
    }
    
    static func setIsAdded(_ isAdded: Bool, fromCurrentUserTo addedOrg: Organization, success: @escaping (Bool) -> Void) {
        if isAdded {
            addOrg(addedOrg, forCurrentUserWithSuccess: success)
        } else {
            print("Org is already added")
            //deleteOrg(addedOrg, forCurrentUserWithSuccess: success)
        }
    }
}
