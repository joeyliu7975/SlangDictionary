//
//  UIView+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import UIKit

extension UIView {
    
    func setShadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat) {
                    layer.shadowColor = color.cgColor
                    layer.shadowOffset = offset
                    layer.shadowOpacity = opacity
                    layer.shadowRadius = radius
    }
    
    func setCorner(radius: CGFloat, maskToBounds: Bool = true) {
        layer.cornerRadius = radius
        layer.masksToBounds = maskToBounds
    }
}
