//
//  UIViewController+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import UIKit

extension UIViewController {
    
    func popAlert(_ style: UIAlertController.Style, actions: [UIAlertAction], title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        actions.forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
}
