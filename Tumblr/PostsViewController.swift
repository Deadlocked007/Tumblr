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
    var posters: [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
        
        refresh.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.estimatedRowHeight = 250
        if Reachability.isConnectedToNetwork(){
            loadPosts()
        }else{
            let alert = UIAlertController(title: "Error", message: "You are not connected to the Internet!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { (alert) in
                self.loadPosts()
            }))
            self.present(alert, animated: true, completion: nil)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
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
        var posterUrlSmall = post.smallImageLink
        let posterUrlBig = post.imageLink
        if ((posters[posterUrlBig]) != nil) {
            DispatchQueue.main.async {
                if (cell.tag == indexPath.row) {
                    cell.postView.image = self.posters[posterUrlBig]
                }
            }
        } else {
            downloadFromURL(url: posterUrlSmall) { (smallPoster) in
                DispatchQueue.main.async {
                    if (cell.tag == indexPath.row) {
                        cell.postView.alpha = 0.0
                        cell.postView.image = smallPoster
                    }
                    
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        cell.postView.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        downloadFromURL(url: posterUrlBig) { (largePoster) in
                            DispatchQueue.main.async {
                                if (cell.tag == indexPath.row) {
                                    UIView.transition(with: cell.postView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                                        cell.postView.image = largePoster
                                    }, completion: nil)
                                    self.posters[posterUrlBig] = largePoster
                                }
                            }
                        }
                    })
                }
            }
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        cell.selectedBackgroundView = backgroundView
        return cell
    }

}
