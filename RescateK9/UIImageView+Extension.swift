//
//  UIImageView+Extension.swift
//  Point Pay
//
//  Created by Gabriel Perez on 03/31/2019.
//  Copyright © 2019 point payments. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(url: String, placeholder: UIImage?) {
        if let pathURL = URL(string: url) {
            self.kf.indicatorType = .activity

            let resource = ImageResource(downloadURL: pathURL, cacheKey: url)
            self.kf.setImage(
                with: resource,
                placeholder: placeholder,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                ])
        } else {
            self.image = placeholder
        }
    }
    
    func clearCacheFor(url: String) {
        let cache = ImageCache.default
        cache.removeImage(forKey: url)
    }
}
    
