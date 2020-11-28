//
//  UISearchBar+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

extension UISearchBar {
    func setTextColor(_ color: UIColor) {
        if let textfield = self.value(forKey: "searchField") as? UITextField {
            textfield.textColor = color
        }
    }
}
