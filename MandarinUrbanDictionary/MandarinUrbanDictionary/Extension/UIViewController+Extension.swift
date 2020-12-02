//
//  UIViewController+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import UIKit

extension UIViewController {
    
    enum Alert {
        case actionSheet, alert
    }
    
    func popAlert(_ style: Alert) {
        
        switch style {
        case .actionSheet:
            let alert = UIAlertController(title: "Report", message: "Do you want to report this post?", preferredStyle: .actionSheet)
            
            let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
                // self.dismiss(animated: true, completion: nil)
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                // self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(reportAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        case .alert:
            break
        }
    }
}
