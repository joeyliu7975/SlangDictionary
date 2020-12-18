//
//  FavoritePresenter.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import UIKit

struct FavoritePresenter: AlertPresenter {
    
    enum Outcome {
        case confirm, cancel
    }
    
    typealias Output = Outcome
    
    let title: String
    
    let message: String
    
    let cancelTitle: String
    
    let confirmTitle: String
    
    var handler: (Output) -> Void
    
    func present(in viewController: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            self.handler(.confirm)
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
            self.handler(.cancel)
        }
        
        alert.addAction(confirmAction)
        
        alert.addAction(cancelAction)
        
        alert.preferredAction = cancelAction
        
        viewController.present(alert, animated: true)
    }
}
