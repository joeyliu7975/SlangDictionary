//
//  UINavigationController+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import UIKit

extension UINavigationController {
    
    var rootViewController: UIViewController? {
        return self.viewControllers.first
    }
    
    func present(_ presenter: UIViewController) {
        
        guard let rootVC = rootViewController else { return }
        
        let presentStyle = RootViewController.checkRootVC(rootVC)
        
        switch presentStyle {
        case .searchVC:
            self.isHeroEnabled = true
            
            self.hero.modalAnimationType = .selectBy(presenting: .fade, dismissing: .pageOut(direction: .right))
        
            self.modalPresentationStyle = .fullScreen
        case .newDefinition:
            self.modalPresentationStyle = .fullScreen
            
            self.modalTransitionStyle = .flipHorizontal
        case .unknow:
            break
        }
        
        presenter.present(self, animated: true)
    }
    
    enum RootViewController {
        case searchVC, newDefinition, unknow
        
        static func checkRootVC(_ viewController: UIViewController) -> RootViewController {
            switch viewController {
            case is SearchPageViewController:
                return searchVC
            case is NewDefinitionViewController:
                return newDefinition
            default:
                return unknow
            }
        }
    }
}
