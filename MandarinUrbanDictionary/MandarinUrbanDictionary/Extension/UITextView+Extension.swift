//
//  UITextView+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/5/20.
//

import UIKit

extension UITextView {
    
    enum Content {
        
        case placeHolder
        
        case startTyping
    }
    
    var hasPlaceholder: Bool {
        
        return self.textColor == UIColor.lightGray ? true : false
        
    }
    
    func clearText() {
        
        self.text.removeAll()
        
    }
    
    func setupContent(_ content: Content) {
        
        switch content {
        case .placeHolder:
            
            self.textColor = .lightGray
            
            self.text = "Please start typing here..."
            
        case .startTyping:
            
            self.textColor = .black
            
        }
    }
    
}
