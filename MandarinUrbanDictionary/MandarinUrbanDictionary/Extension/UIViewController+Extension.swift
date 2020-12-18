//
//  UIViewController+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import UIKit

extension UIViewController {
    
    func popAlert(_ style: Alert, completion: @escaping () -> Void) {
        switch style {
        case .favorite:
            let presenter = FavoritePresenter(
                title: "Favorite Words",
                message: "Are you sure you want to delete all favorite words",
                cancelTitle: "Cancel",
                confirmTitle: "Delete All") { [unowned self] (outcome) in
                switch outcome {
                case .confirm:
                    completion()
                case .cancel:
                    break
                }
            }
            
            presenter.present(in: self)
            
        case .report:
            let presenter = ReportPresenter(
                title: "Report",
                message: "Do you want to report this definition",
                cancelTitle: "Cancel",
                reportTitle: "Report") { (outcome) in
                switch outcome {
                case .report:
                    // Call API Here...
                    completion()
//                    let reportVC = ReportViewController()
//
//                    let nav = UINavigationController(rootViewController: reportVC)
//
//                    nav.modalPresentationStyle = .fullScreen
//
//                    nav.modalTransitionStyle = .coverVertical
//
//                    self.present(nav, animated: true)
                case .cancel:
                    // Do Absolutely Nothing
    //                self.dismiss(animated: true, completion: nil)
                break
                }
            }
            
            presenter.present(in: self)
        }
    }
    
    enum Alert {
        case report, favorite
    }
}
