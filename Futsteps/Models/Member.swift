//
//  Member.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 7/25/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Member: NSObject{

    let uid: String
    let organization_name: String?
    //set it to an optional because if there is no org when a member is created it will not go to the next screen.
    var username: String
    
    init(uid: String, username: String, organization_name: String){
        self.uid = uid
        self.username = username
        self.organization_name = organization_name
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let username = dict["username"] as? String
        else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        self.organization_name = dict["organization_name"] as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String,
            let organization_name = aDecoder.decodeObject(forKey: Constants.UserDefaults.organization_name) as? String
            else { return nil }
        
        self.uid = uid
        self.username = username
        self.organization_name = organization_name
    
        super.init()
    }
    
    
    private static var _current: Member?
    
    static var current: Member {
        
        guard let currentMember = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // If _current isn't nil, it will be returned to the organization.
        return currentMember
    }
    
    
    
    class func setCurrent(_ member: Member, writeToUserDefaults: Bool = false) {
        // Checking if the boolean value for writeToUserDefaults is true.
        //If so, we write the user object to UserDefaults.
        if writeToUserDefaults{
            // We use NSKeyedArchiver to turn our user object into Data. We needed to implement the NSCoding protocol and inherit from NSObject to use NSKeyedArchiver.
            let data = NSKeyedArchiver.archivedData(withRootObject: member)
            
            // We store the data for our current user with the correct key in UserDefaults.
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
        _current = member
    }
    
}

extension Member: NSCoding {
    //Using NSCoding to enable user to keep the info on their phone when they leave the app and come back.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
        
        //aCoder.encode(organization, forKey: Constants.UserDefaults.user)
    }
}
