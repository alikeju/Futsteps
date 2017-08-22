//
//  Post.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/10/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post: NSObject{
    
    var key: String?
    let streetname: String
    let name: String
    let numOfDoors: String
    let timeElapsed: String
    let sideOfStreet: String
    let comments: String
    var creationDate: Date
    
    
    // MARK: - Init
    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["streetname" : streetname,
                "name" : name,
                "numOfDoors" : numOfDoors,
                "sideOfStreet" : sideOfStreet,
                "comments" : comments,
                "timeElapsed" : timeElapsed,
                "created_at" : createdAgo]
    }
    
    
    init (streetname: String, name: String, numOfDoors: String, timeElapsed: String, sideOfStreet: String, comments: String){
        
        self.streetname = streetname
        self.name = name
        self.numOfDoors = numOfDoors
        self.timeElapsed = timeElapsed
        self.sideOfStreet = sideOfStreet
        self.comments = comments
        self.creationDate = Date()
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let timeElapsed = dict["timeElapsed"] as? String,
            let comments = dict["comments"] as? String,
            let name = dict["name"] as? String,
            let numOfDoors = dict["numOfDoors"] as? String,
            let sideOfStreet = dict["sideOfStreet"] as? String,
            let streetname = dict["streetname"] as? String,
            let createdAgo = dict["created_at"] as? TimeInterval
            
            else { return nil }
        
        
        self.key = snapshot.key
        self.streetname = streetname
        self.name = name
        self.numOfDoors = numOfDoors
        self.timeElapsed = timeElapsed
        self.sideOfStreet = sideOfStreet
        self.comments = comments
        self.creationDate = Date() //temp
        self.creationDate = Date(timeIntervalSince1970: createdAgo)
        
        
    }
}

