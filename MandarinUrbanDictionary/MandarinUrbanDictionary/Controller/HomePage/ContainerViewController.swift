//
//  ContainerViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var centerNavigationController: UINavigationController!
    
    var centerViewController: HomePageViewController!
    
    var currentState: SlideOutState = .center
    
    var leftViewController: SidePanelViewController?
    
    var centerPanelExpandedOffset: CGFloat {
        return UIScreen.main.bounds.width * 0.217
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setup()
        
        animation()
        
    }
}

private extension ContainerViewController {
    
    func animation() {
        
        guard let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() else { return }
        
        view.addSubview(launchScreen.view)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut) {
            launchScreen.view.frame = CGRect(x: launchScreen.view.center.x, y: launchScreen.view.center.y, width: 0, height: 0)
        } completion: { (_) in
            launchScreen.view.removeFromSuperview()
        }

    }
    
    func setup() {
        
        centerViewController = HomePageViewController()
        
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        
        view.addSubview(centerNavigationController.view)
        
        addChild(centerNavigationController)
        
        centerNavigationController.didMove(toParent: self)
    }
    
    func setupNavigationController() {
        
        self.navigationItem.setBarAppearance(with: .clear)
        
    }
}

extension ContainerViewController: CenterViewControllerDelegate {
    
    func writeNewWord() {
        
        let addNewWordVC = AddNewWordViewController()
    
        present(addNewWordVC, animated: true)
    }
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            
            addLeftPanelViewController()
            
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        
        guard leftViewController == nil else { return }
        
        let sidePanelVC = SidePanelViewController()
        
        sidePanelVC.delegate = self
        
        addChildSidePanelController(sidePanelVC)
        
        leftViewController = sidePanelVC
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChild(sidePanelController)
        
        sidePanelController.didMove(toParent: self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            
            currentState = .leftPanelExpanded
            
            animateCenterPanelXPosition(
                targetPosition: centerNavigationController.view.frame.width
                    - centerPanelExpandedOffset
            )
        } else {
            
            animateCenterPanelXPosition(targetPosition: 0) {_ in
                
                self.currentState = .center
                
                self.leftViewController?.view.removeFromSuperview()
                
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(
        targetPosition: CGFloat,
        completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.centerNavigationController.view.frame.origin.x = targetPosition
            },
            completion: completion
        )
    }
}

extension ContainerViewController: LeftViewControllerDelegate {
    
    func navigate(to page: SidePanel) {
        animateLeftPanel(shouldExpand: false)
        
        var destinationVC: UIViewController?
        
        switch page {
        case .homePage:
            
            centerNavigationController.popToRootViewController(animated: true)
        
        case .dailySlang:
            break
        case .top5:
            
            destinationVC = RankViewController()
            
            if let desVC = destinationVC as? RankViewController {
                desVC.clickSideMenu = {
                    self.toggleLeftPanel()
                }
            }
            
        case .favorite:
            
            destinationVC = FavoriteViewController()
            
            if let desVC = destinationVC as? FavoriteViewController {
                
                desVC.clickSideMenu = {
                    self.toggleLeftPanel()
                }
                
                desVC.setNavigationBarTitle(title: "Favorites")
            }
            
        case .recents:
            
            destinationVC = FavoriteViewController()
            
            if let desVC = destinationVC as? FavoriteViewController {
                
                desVC.clickSideMenu = {
                    self.toggleLeftPanel()
                }
                
                desVC.setNavigationBarTitle(title: "Recents")
            }
        case .quiz:
            
            destinationVC = QuizViewController()
            
            if let desVC = destinationVC as? QuizViewController {
                desVC.clickSideMenu = {
                    self.toggleLeftPanel()
                }
            }
            
        case .login:
            break
        }
        
        guard let desVC = destinationVC else { return }
        
        centerNavigationController.pushViewController(desVC, animated: true)
    }
}

enum SlideOutState: Equatable {
    case center
    case leftPanelExpanded
}
