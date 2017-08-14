//
//  ListNotesTableViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/9/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ListNotesTableViewController: UIViewController {
    
    @IBOutlet var streetListTableView: UITableView!
    
    var dictDetails: [String:AnyObject]?
    
    var valueToPass: String?
    
    var posts = [Post?](){
        didSet{
            streetListTableView.reloadData()
        }
    }
    
    let currentUser = Member.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MemberService.posts(for: Member.current) { (posts) in
            self.posts = posts
            self.streetListTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.streetListTableView.indexPathForSelectedRow {
                let post = posts[indexPath.row] as! [String: AnyObject]
                let postDetails = post["postID"] as? String
                let controller = segue.destination as! AddStreetsViewController
                controller.postDetails = postDetails
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToListNotesTableViewController(_ segue: UIStoryboardSegue) {
        
    }
    
}

extension ListNotesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let products = posts[indexPath.row]["value"] as? [[String:String]]{
//            valueToPass = products
//            performSegue(withIdentifier: "toProducts", sender: self)
//        }
//    }


}
