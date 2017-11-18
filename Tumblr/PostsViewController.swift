//
//  PostsViewController.swift
//  Tumblr
//
//  Created by Siraj Zaneer on 11/18/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {

    var posts = [Post]()
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
        
        refresh.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.estimatedRowHeight = 250
        loadPosts()
    }

    @objc func loadPosts() {
        TumblrClient.sharedInstance.getPosts(success: { (posts) in
            self.posts = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refresh.endRefreshing()
            }
        }) {
            print("Oh Oh")
            self.refresh.endRefreshing()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.postView.image = nil
        cell.tag = indexPath.row
        let post = posts[indexPath.row]
        downloadFromURL(url: post.imageLink) { (image) in
            DispatchQueue.main.async {
                if cell.tag == indexPath.row {
                    cell.postView.image = image
                }
            }
        }
        return cell
    }

}
