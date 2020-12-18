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
        
        return self.textingStauts == .placeHolder ? true : false
        
    }
    
    func clearText() {
        
        self.text.removeAll()
        
    }
    
    func textingStatus(with content: Content) {
        
        switch content {
        
        case .placeHolder:
            
            self.textColor = .placeholderText
            
        case .startTyping:
            
            self.textColor = .black
            
        }
    }
    
    var textingStauts: Content {
        switch self.textColor {
        case UIColor.placeholderText:
            return .placeHolder
        default:
            return .startTyping
        }
    }
    
}
