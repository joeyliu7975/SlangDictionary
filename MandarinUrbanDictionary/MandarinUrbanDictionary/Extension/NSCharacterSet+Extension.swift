//
//  NSCharacterSet+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/13/20.
//

import Foundation

extension NSCharacterSet {
    
    class var textViewValidString: NSCharacterSet {
        return NSCharacterSet(charactersIn: "@#$%^&*()_+{}[]|\"<>~`/:;-=\\¥'£•¢")
    }
    
    class var searchBarValidString: NSCharacterSet {
        return NSCharacterSet(charactersIn: " @#$%^&*()_+,.。{}[]|\"<>~`/:;-=\\¥'£•¢\n")
    }
    
    class var newWordTextField: NSCharacterSet {
        return NSCharacterSet(charactersIn: "  @#$%^&*()_+,.。{}[]|\"<>~`/:;-=\\¥'£•¢\n")
    }
}
