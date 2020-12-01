//
//  CardView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

@IBDesignable

class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {
        
        layer.cornerRadius = cornerRadius
        
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        let shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        
    }
}
    
