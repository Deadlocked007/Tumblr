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
    var id: Int
    var postUrl: String
    var slug: String
    var date: Date
    var noteCount: Int
    var caption: String
    var originalPhoto: String
    var smallPhoto: String
    
    init(postInfo: Dictionary<String, Any>) {
        blogName = postInfo["blog_name"] as! String
        id = postInfo["id"] as! Int
        postUrl = postInfo["post_url"] as! String
        slug = postInfo["slug"] as! String
        date = Date(timeIntervalSince1970: postInfo["timestamp"] as! Double)
        noteCount = postInfo["note_count"] as! Int
        caption = postInfo["caption"] as! String
        let photos = postInfo["photos"] as! [Dictionary<String, Any>]
        let first = photos[0]
        let originalSize = first["original_size"] as! Dictionary<String, Any>
        originalPhoto = originalSize["url"] as! String
        let altSizes = first["alt_sizes"] as! [Dictionary<String, Any>]
        let smallest = altSizes[altSizes.count - 1]
        smallPhoto = smallest["url"] as! String
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
