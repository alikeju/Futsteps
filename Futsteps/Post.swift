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
    let numOfDoors: String
    let timeElapsed: String
    let sideOfStreet: String
    let comments: String
    var creationDate: Date
    
    // MARK: - Init
    
    init (streetName: String, name: String, numOfDoors: String, timeElapsed: String, sideOfStreet: String, comments: String){
        
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
            let numOfDoors = dict["number_of_doors"] as? String,
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


//private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
//    // Create a reference to the current user. We'll need the user's UID to construct the location of where we'll store our post data in our database.
//    let currentUser = User.current
//    
//    // Initialize a new Post using the data passed in by the parameters.
//    let post = Post(imageURL: urlString, imageHeight: aspectHeight)
//    
//    // Convert the new post object into a dictionary so that it can be written as JSON in our database. We haven't added this computed variable to our Post object yet so the compiler will throw an error right now.
//    let dict = post.dictValue
//    
//    // Construct the relative path to the location where we want to store the new post data. Notice that we're using the current user's UID as child nodes to keep track of which Post belongs to which user.
//    let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
//    
//    // Write the data to the specified location.
//    postRef.updateChildValues(dict)
//}
//
//init?(snapshot: DataSnapshot) {
//    guard let dict = snapshot.value as? [String : Any],
//        let imageURL = dict["image_url"] as? String,
//        let imageHeight = dict["image_height"] as? CGFloat,
//        let createdAgo = dict["created_at"] as? TimeInterval
//        else { return nil }
//    
//    self.key = snapshot.key
//    self.imageURL = imageURL
//    self.imageHeight = imageHeight
//    self.creationDate = Date(timeIntervalSince1970: createdAgo)
//}
