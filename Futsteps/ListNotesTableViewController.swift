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
    //LOOPING BEFORE IT GOES TO THE INITIALIZER
    
    @IBOutlet var streetListTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    //    var posts = [Post]() {
    //        didSet {
    //            streetListTableView.reloadData()
    //
    //        }
    //    }
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        streetListTableView.delegate = self as? UITableViewDelegate
        streetListTableView.dataSource = self
        
        //configureTableView()
        //  reloadTimeline()
        
        MemberService.timeline { (posts) in
            self.posts = posts
            self.streetListTableView.reloadData()
        }
        super.viewDidLoad()
        
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
            
            self.streetListTableView.reloadData()
        }
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        MemberService.posts(for: Member.current) { (posts) in
    //            self.posts = posts
    //            self.streetListTableView.reloadData()
    //        }
    //    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.streetListTableView.indexPathForSelectedRow {
                let post = posts[indexPath.row] //as! [String: Any]
                let postDetails = post.dictValue
                // let postDetails = post["postID"] as? String
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
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.streetname
        post.creationDate = (Date() as NSDate) as Date
        //note.modificationTime = Date() as NSDate
        cell.detailTextLabel?.text = post.creationDate.convertToString()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "showDetails", sender: self)
//    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return posts.count
//    }
}




