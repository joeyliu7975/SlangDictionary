//
//  UIColor+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/26/20.
//

import UIKit

private enum Color: String {
    
    case homepageDarkBlue = "#31C1FF"
    
    case darkGreen = "6D9B2C"
    
    case barButtonRed = "#FC573A"
    
    case popularWordCollection = "DFBDA9"
    
    case searchBarBlue = "018ECB"
    
    case homepageLightBlue = "D0EFFF"
    
    case searchButtonTitleGray = "909090"
    
    case rankLabelBackgroundBlue = "8EDAFF"
    
    case separatorlineBlue = "0E8ECB"
    
    case sidePanelBlue = "8FDEFF"
}

extension UIColor {
    /// HomePage backgroundColor
    static let homepageDarkBlue = renderColor(.homepageDarkBlue)
    /// RedColor for barButtonItem
    static let barButtonRed = renderColor(.barButtonRed)
    /// GreenColor for searchBar containerView
    static let searchBarBlue = renderColor(.searchBarBlue)
    /// Dark Green for NavigationBar 
    static let darkGreen = renderColor(.darkGreen)
    
    static let popularWordCollectionBrown = renderColor(.popularWordCollection)
    
    static let homepageLightBlue = renderColor(.homepageLightBlue)
    
    static let searchButtonTitleGray = renderColor(.searchButtonTitleGray)
    /// lightBlue for rankLabel backgroundView
    static let rankLabelBackgroundBlue = renderColor(.rankLabelBackgroundBlue)
    /// darkBlue for separatorline
    static let separatorlineBlue = renderColor(.separatorlineBlue)
    
    static let sidePanelBlue = renderColor(.sidePanelBlue)
    
    static let transparentBlack = UIColor.black.withAlphaComponent(0.5)
    
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
