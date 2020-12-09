//
//  ReportPresenter.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import UIKit

struct ReportPresenter {
    
    enum Outcome {
        case report, cancel
    }
    
    let title: String
    
    let message: String
    
    let cancelTitle: String
    
    let reportTitle: String
    
    let handler: (ReportPresenter.Outcome) -> Void
    
    func present(in viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let reportAction = UIAlertAction(title: reportTitle, style: .destructive) { (_) in
            self.handler(.report)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
            self.handler(.cancel)
        }
        
        alert.addAction(cancelAction)
        
        alert.addAction(reportAction)
        
        viewController.present(alert, animated: true)
    }
}
