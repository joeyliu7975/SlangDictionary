//
//  UINavigation+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/30/20.
//

import UIKit

extension UINavigationController {
    func removeNavigationBarShadow() {
        self.navigationBar.shadowImage = UIImage()
    }
    
    func removeNavigationBarBackground() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
}
