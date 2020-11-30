//
//  UISearchBar+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

extension UISearchBar {
    func setTextColor(_ color: UIColor, cursorColor: UIColor? = .lightGray) {
        if let textfield = self.value(forKey: "searchField") as? UITextField,
           let tintColor = cursorColor {
            textfield.textColor = color
            self.tintColor = tintColor
        }
    }
    
    func setClearButton(color: UIColor) {
        let searchField = self.searchTextField
        
        guard let clearButton = searchField.value(forKey: "_clearButton") as? UIButton else { return }
        
        let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
       // Set the template image copy as the button image
        clearButton.setImage(templateImage, for: .normal)
       // Finally, set the image color
        clearButton.tintColor = color
    }
    
    func setSearchIcon(color: UIColor) {
        let searchField = self.searchTextField
        
        if let searchImage = searchField.leftView as? UIImageView {
            searchImage.image = searchImage.image?.withRenderingMode(.alwaysTemplate)
            searchImage.tintColor = color
        }
    }
}
