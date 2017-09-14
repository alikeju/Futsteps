//
//  Organization.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/24/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import UIKit

class Organization: NSObject {
    
    var isAdded = false
    
    var orgs = [Organization]()
    let uid: String
    
    // MARK: - Properties
    
    let organization_name: String
    let member_uid: String
    // MARK: - Init
    
    var dictValue: [String : Any] {
        
        return ["organizaiton_name" : organization_name,
                "member_uid" : member_uid]
    }
    
    init(organization_name: String, member_uid: String, uid: String) {
        self.organization_name = organization_name
        self.member_uid = member_uid
        self.uid = uid
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let organization_name = dict["organization_name"] as? String,
        let member_uid = dict["member_uid"] as? String
        else { return nil }
        
        self.organization_name = organization_name
        self.member_uid = member_uid
        self.uid = snapshot.key
    }
}



