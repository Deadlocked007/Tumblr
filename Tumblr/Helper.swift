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

extension String {
    init(htmlEncodedString: String) {
        self.init()
        guard let encodedData = htmlEncodedString.data(using: .utf8) else {
            self = htmlEncodedString
            return
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            self = attributedString.string
        } catch {
            print("Error: \(error)")
            self = htmlEncodedString
        }
    }
}
