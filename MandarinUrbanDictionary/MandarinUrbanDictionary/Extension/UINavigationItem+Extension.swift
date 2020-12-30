//
//  UINavigationItem+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

extension UINavigationItem {
    
    static let titleAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "PingFang SC", size: 20)!
    ]
    
    func setBarAppearance(color: UIColor, titleTextAttrs: [NSAttributedString.Key: NSObject]? = nil, title: String? = nil) {
        
        let barAppearance = UINavigationBarAppearance()
        
        barAppearance.shadowColor = .clear
    
        if let textAttrs = titleTextAttrs,
           let title = title {
            
            barAppearance.titleTextAttributes = textAttrs
            
            self.title = title
            
        }
        
        barAppearance.backgroundColor = color
        
        standardAppearance = barAppearance
    }
}
