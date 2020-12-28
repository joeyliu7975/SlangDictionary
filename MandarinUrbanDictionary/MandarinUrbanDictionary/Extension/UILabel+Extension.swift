//
//  UILabel+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/12/20.
//

import UIKit

extension UILabel {
    
    func replaceKeywordColor(with color: UIColor, keyword: String) {
        
        guard let wholeText = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: wholeText)
        
        let rangeMain = (wholeText as NSString).range(of: (wholeText as NSString) as String)
        
        let rangeKeyword = (wholeText as NSString).range(of: keyword)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: rangeMain)
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: rangeKeyword)
        
        let attrs = [NSAttributedString.Key.font: UIFont(name: "PingFang SC", size: 20)]
        
        attributedString.addAttributes(attrs, range: rangeKeyword)
        
        self.attributedText = attributedString
    }
}
