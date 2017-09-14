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
    
    let refreshControl = UIRefreshControl()
    
    var posts = [Post](){
        didSet {
            streetListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        streetListTableView.delegate = self as? UITableViewDelegate
        streetListTableView.dataSource = self
        
        //configureTableView()
        //  reloadTimeline()
        
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MemberService.timeline { (posts) in
            self.posts = posts
        }
    }
    
    func configureTableView() {
        // remove separators for empty cells
        streetListTableView.tableFooterView = UIView()
        // remove separators from cells
        streetListTableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        streetListTableView.addSubview(refreshControl)
    }
    
    func reloadTimeline() {
        MemberService.timeline { (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.streetListTableView.indexPathForSelectedRow {
                    
                let post = posts[indexPath.row] //as! [String: Any]
            //    let postDetails = post.dictValue
                let controller = segue.destination as! AddStreetsViewController
                //controller.postDetails = postDetails
                controller.post = post
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
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.streetname
        cell.detailTextLabel?.text = post.creationDate.convertToString()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       // return posts[indexPath.row].memberUID == Member.current.uid || Organization.current != nil
        return posts[indexPath.row].memberUID == Member.current.uid
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if (editingStyle == .delete) {
            
            Database.database().reference().child("org_posts").child(Member.current.uid).child(posts[indexPath.row].key!).removeValue()
            posts.remove(at: indexPath.item)
            tableView.reloadData()
        }
        
//        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//            if (editingStyle == .delete) {
//                Database.database().reference().child("org_posts").child((Member.current.uid)).child(posts[indexPath.row].key!).removeValue()
//                posts.remove(at: indexPath.item)
//                tableView.reloadData()
//            }
//            
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}




