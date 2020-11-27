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
    
    case homeLogo = "homeLogo"
    
    case search = "search"
    
    case matrix = "matrix"
}

extension UIImage {
    
    static let featherPen = setImage(.featherPen)
    
    static let list = setImage(.list)
    
    static let homeLogo = setImage(.homeLogo)
    
    static let search = setImage(.search)
    
    static let matrix = setImage(.matrix)
    
    private static func setImage(_ image: Image) -> UIImage {
        guard let customImage = UIImage(named: image.rawValue) else {
            return UIImage()
        }
        
        return customImage
    }
}
