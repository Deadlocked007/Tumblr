//
//  PostsViewController.swift
//  Tumblr
//
//  Created by Siraj Zaneer on 11/18/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit


var posters: [String:UIImage] = [:]

class PostsViewController: UITableViewController {

    var posts = [Post]()
    let refresh = UIRefreshControl()
    let multiplier = 20
    var offset = 0
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
        refresh.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
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
        isMoreDataLoading = true
        if refresh.isRefreshing {
            offset = 0
        }
        
        TumblrClient.sharedInstance.getPosts(offset: multiplier * offset, success: { (posts) in
            DispatchQueue.main.async {
                
                if self.refresh.isRefreshing {
                    self.posts = posts
                } else {
                    self.posts.append(contentsOf: posts)
                }
                self.tableView.reloadData()
                self.refresh.endRefreshing()
                self.isMoreDataLoading = false
            }
        }) {
            print("Oh Oh")
            self.refresh.endRefreshing()
            self.isMoreDataLoading = false
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                offset += 1
                
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadPosts()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        if ((posters["https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar"]) != nil) {
            DispatchQueue.main.async {
                profileView.image = posters["https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar"]
            }
        } else {
            downloadFromURL(url: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar") { (image) in
                DispatchQueue.main.async {
                    profileView.image = image
                    posters["https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar"] = image
                }
            }
        }
        headerView.addSubview(profileView)
        
        let post = posts[section]
        
        let dateLabel = UILabel(frame: CGRect(x: 50, y: 10, width: tableView.frame.width - 50, height: 30))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dateLabel.text = dateFormatter.string(from: post.date)
        headerView.addSubview(dateLabel)
        
        return headerView

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        cell.postView.image = nil
        cell.tag = indexPath.section
        let post = posts[indexPath.section]
        let posterUrlSmall = post.smallPhoto
        let posterUrlBig = post.originalPhoto
        if ((posters[posterUrlBig]) != nil) {
            DispatchQueue.main.async {
                if (cell.tag == indexPath.section) {
                    cell.postView.image = posters[posterUrlBig]
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
                                if (cell.tag == indexPath.section) {
                                    UIView.transition(with: cell.postView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                                        cell.postView.image = largePoster
                                    }, completion: nil)
                                    posters[posterUrlBig] = largePoster
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier else {
            return
        }
        
        switch id {
        case "postDetailSegue":
            let destination = segue.destination as! PostDetailViewController
            let cell = sender as! PostCell
            let indexPath = tableView.indexPath(for: cell)!
            destination.post = posts[indexPath.section]
        default:
            break
        }
    }
}
