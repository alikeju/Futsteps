//
//  Constants.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/25/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation

//constants can be reused in other code
//Xcode will allow us to quickly remember and fill in constants with autocomplete
//the compiler will throw an error if we misspell an identifier

struct Constants {
    struct Segue {
        static let toCreateUser = "toCreateUser"
        static let toSearchOrg = "toSearchOrg"
    }
    
    struct UserDefaults {
        static let currentUser = "user"
        static let uid = "uid"
        static let username = "username"
        static let organization_name = "organization_name"
        static let org_uid = "org_uid"
    }
}
