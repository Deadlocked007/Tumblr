//
//  Helper.swift
//  Tumblr
//
//  Created by Siraj Zaneer on 11/18/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

func downloadFromURL(url: String, success: @escaping (UIImage) -> ()) {
    DispatchQueue.global().async {
        guard let url = URL(string: url) else {
            return
        }
        
        guard let imageData = try? Data(contentsOf: url) else {
            return
        }
        
        guard let image = UIImage(data: imageData) else {
            return
        }
        
        success(image)
    }
}

