//
//  Post.swift
//  Tumblr
//
//  Created by Siraj Zaneer on 11/18/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

class Post {
    var blogName: String
    var postUrl: String
    var imageLink: String
    
    init(postInfo: Dictionary<String, Any>) {
        blogName = postInfo["blog_name"] as! String
        postUrl = postInfo["post_url"] as! String
        let images = postInfo["photos"] as! [Dictionary<String, Any>]
        let firstImage = images[0]
        let firstImageOg = firstImage["original_size"] as! Dictionary<String, Any>
        imageLink = firstImageOg["url"] as! String
    }
}

/*
 type    "photo"
 blog_name    "humansofnewyork"
 id    167527337576
 post_url    "http://www.humansofnewyo…n-a-lot-of-people-in-my"
 slug    "i-want-to-be-a-comedian-a-lot-of-people-in-my"
 date    "2017-11-15 20:05:17 GMT"
 timestamp    1510776317
 state    "published"
 format    "html"
 reblog_key    "We7jna3R"
 tags    []
 short_url    "https://tmblr.co/ZITdqx2S1Q4ve"
 summary    "“I want to be a comedian… of a good joke that..."
 is_blocks_post_format    false
 recommended_source    null
 recommended_color    null
 note_count    2234
 caption    "<p>\n\n“I want to be a c…that one.”\n\n<br/></p>"
 reblog    {…}
 trail    […]
 image_permalink    "http://www.humansofnewyo….com/image/167527337576"
 photos    […]
 can_like    false
 can_reblog    false
 can_send_in_message    true
 can_reply    false
 display_avatar    true
 */
