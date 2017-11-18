//
//  FullScreenViewController.swift
//  Tumblr
//
//  Created by Siraj Zaneer on 11/18/17.
//  Copyright © 2017 Siraj Zaneer. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.layer.cornerRadius = 0.5 * cancelButton.bounds.size.width
        cancelButton.clipsToBounds = true
        scrollView.delegate = self
        imageView.image = image
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FullScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
