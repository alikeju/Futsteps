//
//  PostService.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/10/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth.FIRUser

class PostService{
    
    static func create(streetName: String, name: String, numOfDoors: String, timeElapsed: String, sideOfStreet: String, comments: String, completion: @escaping(String) -> Void){
        
        let member = Member.current.username
        let currentMember = Member.current
        
        let post = (streetName: streetName, name: name, numOfDoors: numOfDoors, timeElapsed: timeElapsed, sideOfStreet: sideOfStreet, comments: comments)
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("user_posts").child(currentMember.uid).childByAutoId()
        let newPostKey = newPostRef.key
        
//        OrganizationService.members(for: currentMember) { (membersUIDs) in
//            let timelinePostDict = ["poster_uid" : currentMember.uid]
//            
//            var updatedData: [String : Any] = ["timeline/\(currentMember.uid)/\(newPostKey)" : timelinePostDict]
//            for uid in membersUIDs{
//                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
//            }
//            let postDict = post.dictValue
//            updatedData["posts/\(currentMember.uid)/\(newPostKey)"] = postDict
//            rootRef.updateChildValues(updatedData)
//        }
        let postAttrs = ["street_name": streetName,
                         "name" : member,
                         "numDoors" : numOfDoors,
                         "timeElapsed" : ServerValue.timestamp(),
                         "sideOfStreet": sideOfStreet,
                         "comments": comments] as [String : Any]
        
        var ref:DatabaseReference? = nil
        
        //you want a variable that stores the key of the post
        ref = Database.database().reference().child("user_posts").child(Member.current.uid).childByAutoId()
        let currentKey = ref?.key
        ref?.setValue(postAttrs) { (error, ref)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        let ref2 = Database.database().reference().child("org_posts").child(Member.current.org_uid!).child(currentKey!)
        
        ref2.setValue(postAttrs) { (error, ref2)  in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
        
        return completion(ref!.key)
    }
    
}

//private static func create(forURLString urlString: String, aspectHeight: CGFloat) {
//    let currentUser = User.current
//    let post = Post(imageURL: urlString, imageHeight: aspectHeight)
//
//    // 1
//    let rootRef = Database.database().reference()
//    let newPostRef = rootRef.child("posts").child(currentUser.uid).childByAutoId()
//    let newPostKey = newPostRef.key
//
//    // 2
//    UserService.followers(for: currentUser) { (followerUIDs) in
//        // 3
//        let timelinePostDict = ["poster_uid" : currentUser.uid]
//
//        // 4
//        var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]
//
//        // 5
//        for uid in followerUIDs {
//            updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
//        }
//
//        // 6
//        let postDict = post.dictValue
//        updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict
//
//        // 7
//        rootRef.updateChildValues(updatedData)
//    }
//}

