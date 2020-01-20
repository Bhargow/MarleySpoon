//
//  jhkj.swift
//  MarleySpoon
//
//  Created by rao on 20/01/20.
//  Copyright © 2020 Bhargow. All rights reserved.
//

import UIKit

class MSDownloadableImageView: UIView {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    var imgUrl: URL! {
        didSet {
            self.downloadImage()
        }
    }
    
    func downloadImage() {
        activityIndicator.startAnimating()
        let data = try? Data(contentsOf: imgUrl)
        self.imageView.image = UIImage(data: data!)
        self.activityIndicator.stopAnimating()
    }
}
