//
//  ReportPresenter.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import UIKit

protocol AlertPresenter {
    
    associatedtype Output
    
    func present(in viewController: UIViewController)
    
    var handler: (Output) -> Void { get }
}

struct ReportPresenter: AlertPresenter {
    
    enum Outcome {
        case report, cancel
    }
    
    typealias Output = Outcome
    
    let title: String
    
    let message: String
    
    let cancelTitle: String
    
    let reportTitle: String
    
    var handler: (Output) -> Void
    
    func present(in viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
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
