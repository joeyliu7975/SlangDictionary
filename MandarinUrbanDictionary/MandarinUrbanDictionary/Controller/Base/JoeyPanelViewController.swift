//
//  JoeyPanelViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit
import Lottie

@objc private protocol SideMenuControling {
    
    var triggerSideMenu: (() -> Void)? { get set }
    
    func removeBackButton()
        
    func makeSideMenuButton()
    
    @objc func toggleLeftPanel()
}

class JoeyPanelViewController: UIViewController, SideMenuControling {
    
    var triggerSideMenu: (() -> Void)?
    
    lazy var animationView: UIView = {
        
       var animationView = AnimationView()
        
        animationView = .init(name: "loading-spinner")
        
        animationView.frame = self.navigationController?.view.bounds ?? view.bounds
        
        animationView.backgroundColor = .white
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.animationSpeed = 2.5
        
        animationView.loopMode = .loop
        
        animationView.play()
        
        return animationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        overrideUserInterfaceStyle = .light
    }
    
    @objc func toggleLeftPanel() {
        
        triggerSideMenu?()
        
    }
    
    func removeBackButton() {
        
        navigationItem.leftBarButtonItem = nil
        
        navigationItem.hidesBackButton = true
    }
    
    func setNavigationBarAppearance(forViewController viewController: SidePanel) {
        
        let title = viewController.instance().name
        
        navigationItem.setBarAppearance(
            color: .cardViewBlue,
            titleTextAttrs: UINavigationItem.titleAttributes,
            title: title
        )
        
    }
    
    func makeSideMenuButton() {
        
        let button = UIButton.makeButton(buttonType: .rightBarButtonItem(image: ImageConstant.list))
        
        button.addTarget(self, action: #selector(toggleLeftPanel), for: .touchDown)
        
        let sideMenuButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = sideMenuButton
        
    }
}
