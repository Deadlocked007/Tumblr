//
//  PostDetailViewController.swift
//  Tumblr
//
//  Created by Siraj Zaneer on 11/18/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {

    @IBOutlet weak var postView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = post.blogName
        
        summaryLabel.text = String(htmlEncodedString: post.caption)
        summaryLabel.sizeToFit()
        if ((posters[post.originalPhoto]) != nil) {
            DispatchQueue.main.async {
                self.postView.image = posters[self.post.originalPhoto]
            }
        } else {
            downloadFromURL(url: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar") { (image) in
                DispatchQueue.main.async {
                    self.postView.image = image
                    posters[self.post.originalPhoto] = image
                }
            }
        }
    }
    
    @IBAction func onLink(_ sender: Any) {
        let url = URL(string: post.postUrl)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
