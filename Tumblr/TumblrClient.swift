//
//  TumblrClient.swift
//  Tumblr
//
//  Created by Siraj Zaneer on 11/18/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

class TumblrClient {
    
    static let sharedInstance = TumblrClient()
    
    func getPosts(success: @escaping ([Post]) -> (), failure: @escaping () -> ()) {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                failure()
            } else if let data = data {
                let jsonData = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary<String, Any>
                let results = jsonData["response"] as! Dictionary<String, Any>
                let postsResult = results["posts"] as! [Dictionary<String, Any>]
                var posts = [Post]()
                for result in postsResult {
                    posts.append(Post(postInfo: result))
                }
                success(posts)
            }
        }
        task.resume()
    }
}

