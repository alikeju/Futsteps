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
    let streetName: String
    let name: String
    let numOfDoors: Int
    let timeElapsed: String
    let sideOfStreet: String
    let comments: String
    var creationDate: Date
    
    // MARK: - Init
    
    init (streetName: String, name: String, numOfDoors: Int, timeElapsed: String, sideOfStreet: String, comments: String){
        
        self.streetName = streetName
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
            let streetName = dict["street_name"] as? String,
            let name = dict["name"] as? String,
            let numOfDoors = dict["number_of_doors"] as? Int,
            let timeElapsed = dict["time_elapsed"] as? String,
            let sideOfStreet = dict["side_of_street"] as? String,
            let comments = dict["comments"] as? String,
            let time = dict["time"] as? TimeInterval
            else { return nil }
        
        self.key = snapshot.key
        self.streetName = streetName
        self.name = name
        self.numOfDoors = numOfDoors
        self.timeElapsed = timeElapsed
        self.sideOfStreet = sideOfStreet
        self.comments = comments
        self.creationDate = Date(timeIntervalSince1970: time)
        
    }
}

