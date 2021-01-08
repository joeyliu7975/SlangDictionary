//
//  UISearchBar+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

extension UISearchBar {
    
    private var searchField: UISearchTextField {
        return self.searchTextField
    }
    
    static func makeSearchBar(_ type: CustomSearchBar, frame: CGRect = .zero) -> UISearchBar {
        
        let searchBar = UISearchBar(frame: frame)
        
        switch type {
        case .navigationSearchBar:
                
            searchBar.setTextColor(.black, cursorColor: .separatorlineBlue)
            
            searchBar.setClearButton(color: .lightGray)
            
            searchBar.setSearchIcon(color: .lightGray)
            
            searchBar.returnKeyType = .default
        }
        
        return searchBar
    }

    
    func setTextColor(_ color: UIColor, cursorColor: UIColor? = .lightGray) {
                                      
        if let textfield = self.value(forKey: "searchField") as? UITextField,
           let tintColor = cursorColor {
            
            textfield.textColor = color
            
            textfield.backgroundColor = .white
                        
            self.tintColor = tintColor
            
        }
    }
    
    func setClearButton(color: UIColor) {
        
        guard let clearButton = searchField.value(forKey: "_clearButton") as? UIButton else { return }
        
        let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
       // Set the template image copy as the button image
        clearButton.setImage(templateImage, for: .normal)
       // Finally, set the image color
        clearButton.tintColor = color
    }
    
    func setSearchIcon(color: UIColor) {
        
        if let searchImage = searchField.leftView as? UIImageView {
            
            searchImage.image = searchImage.image?.withRenderingMode(.alwaysTemplate)
            
            searchImage.tintColor = color
            
        }
    }
    
    enum CustomSearchBar {
        case navigationSearchBar
    }
}
