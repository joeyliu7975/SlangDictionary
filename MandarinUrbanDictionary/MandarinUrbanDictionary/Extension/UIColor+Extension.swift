//
//  UIColor+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/26/20.
//

import UIKit

private enum Color: String {
    
    case lightGreen = "#FEFFF2"
    
    case darkGreen = "6D9B2C"
    
    case barButtonRed = "#FC573A"
    
    case popularWordCollection = "DFBDA9"
    
    case searchBarGreen = "90C14A"
    
    case logoCircleGreen = "CCD8BB"
    
    case searchButtonTitleGray = "909090"
}

extension UIColor {
    /// HomePage backgroundColor
    static let lightGreen = renderColor(.lightGreen)
    /// RedColor for barButtonItem
    static let barButtonRed = renderColor(.barButtonRed)
    /// GreenColor for searchBar containerView
    static let searchBarGreen = renderColor(.searchBarGreen)
    /// Dark Green for NavigationBar 
    static let darkGreen = renderColor(.darkGreen)
    
    static let popularWordCollectionBrown = renderColor(.popularWordCollection)
    
    static let logoCircleGreen = renderColor(.logoCircleGreen)
    
    static let searchButtonTitleGray = renderColor(.searchButtonTitleGray)
    
    private static func renderColor(_ color: Color) -> UIColor {
        
        return UIColor.hexStringToUIColor(hex: color.rawValue)
    }
    
    static func hexStringToUIColor(hex: String) -> UIColor {

        var colorString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if colorString.hasPrefix("#") {
            colorString.remove(at: colorString.startIndex)
        }

        if (colorString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
