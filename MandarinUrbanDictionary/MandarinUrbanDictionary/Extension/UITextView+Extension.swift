//
//  UITextView+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/5/20.
//

import UIKit

extension UITextView {
    
    enum Content {
        
        case placeHolder(String)
        
        case startTyping(color: UIColor)
    }
    
    var hasPlaceholder: Bool {
        
        return self.textColor == UIColor.lightGray ? true : false
        
    }
    
    func clearText() {
        
        self.text.removeAll()
        
    }
    
    func setupContent(_ content: Content) {
        
        switch content {
        case .placeHolder(let text):
            
            self.textColor = .lightGray
            
            self.text = text
            
        case .startTyping(let color):
            
            self.textColor = color
            
        }
    }
    
}
