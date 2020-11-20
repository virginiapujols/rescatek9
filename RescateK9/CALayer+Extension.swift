//
//  CALayer+Extension.swift
//  Point Pay
//
//  Created by Virginia Pujols on 7/21/19.
//  Copyright © 2019 point payments. All rights reserved.
//

import UIKit

extension CALayer {
    func applyShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 0, blur: CGFloat = 4, spread: CGFloat = 0) {
        
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale

        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
    }
}
