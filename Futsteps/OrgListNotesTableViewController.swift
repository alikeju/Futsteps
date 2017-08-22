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
    
}

extension OrgListNotesTableViewController: UITableViewDataSource {
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
    
}
