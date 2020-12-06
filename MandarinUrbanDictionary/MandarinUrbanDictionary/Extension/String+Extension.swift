//
//  String+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/6/20.
//

import Foundation

extension String {
    
    func fuzzyMatch(_ needle: String) -> Bool {
        
        if needle.isEmpty { return true }
        
        var remainder = needle[...]
        
        for char in self {
            if char == remainder[remainder.startIndex] {
                
                remainder.removeFirst()
                
                if remainder.isEmpty { return true }
                
            }
        }
        
        return false
    }
    
}
