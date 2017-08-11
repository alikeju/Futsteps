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
    
    // MARK: - Properties
    
    let uid: String
    let organization: String
    
    // MARK: - Init
    
    init(uid: String, organization: String) {
        self.uid = uid
        self.organization = organization
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let organization = dict["organization_name"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.organization = organization
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let organization = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
            else { return nil }
        
        self.uid = uid
        self.organization = organization
        
        super.init()
    }

    
    //MARK: - Class Methods
    
    class func setCurrent(_ organization: Organization, writeToUserDefaults: Bool = false) {
        // Checking if the boolean value for writeToUserDefaults is true.
        //If so, we write the user object to UserDefaults.
        if writeToUserDefaults {
            // We use NSKeyedArchiver to turn our user object into Data. We needed to implement the NSCoding protocol and inherit from NSObject to use NSKeyedArchiver.
            let data = NSKeyedArchiver.archivedData(withRootObject: organization)
            
            // We store the data for our current user with the correct key in UserDefaults.
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        
       // _current = organization
    }
    
//If something goes terribly wrong then uncomment. If not then delete.
//    func configure(cell: AddOrgCell, atIndexPath indexPath: IndexPath) {
//        let org = orgs[indexPath.row]
//        
//        cell.orgNameLabel.text = org.organization
//        cell.addButton.isSelected = org.isAdded
//    }
}

extension Organization: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
        aCoder.encode(organization, forKey: Constants.UserDefaults.username)
    }
}

