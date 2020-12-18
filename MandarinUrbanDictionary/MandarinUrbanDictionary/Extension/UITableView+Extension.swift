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
    
    func makeCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("TableView Cell Does Not Exist!")
        }
        
        return cell
    }
}
