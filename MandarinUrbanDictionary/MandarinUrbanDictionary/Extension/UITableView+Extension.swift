//
//  UITableView+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

extension UITableView {
    
    func registerCell(_ cellName: String) {
        let nib = UINib(nibName: cellName, bundle: nil)
        
        self.register(nib, forCellReuseIdentifier: cellName)
    }
    
    func registerHeaderFooterCell(_ cellName: String) {
        let nib = UINib(nibName: cellName, bundle: nil)
        
        self.register(nib, forHeaderFooterViewReuseIdentifier: cellName)
    }
}
