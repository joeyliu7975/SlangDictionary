//
//  UIImageView+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/26/20.
//

import UIKit

private enum Image: String {
    
    case list = "list"
    
    case featherPen = "featherPen"
    
    case homeLogo = "Logo"
}

extension UIImage {
    
    static let featherPen = setImage(.featherPen)
    
    static let list = setImage(.list)
    
    static let homeLogo = setImage(.homeLogo)
    
    private static func setImage(_ image: Image) -> UIImage {
        guard let customImage = UIImage(named: image.rawValue) else {
            return UIImage()
        }
        
        return customImage
    }
}
