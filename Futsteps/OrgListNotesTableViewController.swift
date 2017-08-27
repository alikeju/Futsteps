//
//  OrgListNotesTableViewController.swift
//  Futsteps
//
//  Created by Alikeju Adejo on 8/21/17.
//  Copyright © 2017 Alikeju Adejo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase

class OrgListNotesTableViewController: UIViewController {
    
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

        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        OrganizationService.timeline { (posts) in
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
        OrganizationService.timeline { (posts) in
            self.posts = posts
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToListNotesTableViewController(_ segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.streetListTableView.indexPathForSelectedRow {
                print("Table view cell tapped")
                let post = posts[indexPath.row] //as! [String: Any]
                //    let postDetails = post.dictValue
                let controller = segue.destination as! OrgAddStreetsViewController
                //controller.postDetails = postDetails
                controller.post = post
            }
        }
    }
    
}

extension OrgListNotesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.streetname
        //post.creationDate = (Date() as NSDate) as Date
        //note.modificationTime = Date() as NSDate
        cell.detailTextLabel?.text = post.creationDate.convertToString()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Database.database().reference().child("org_posts").child((Organization.current?.uid)!).child(posts[indexPath.row].key!).removeValue()
            posts.remove(at: indexPath.item)
            tableView.reloadData()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
