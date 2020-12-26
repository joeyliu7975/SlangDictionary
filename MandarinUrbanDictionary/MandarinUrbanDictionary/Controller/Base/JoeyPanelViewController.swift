//
//  JoeyPanelViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit
import Lottie

@objc private protocol SidePanelControl {
    
    var clickSideMenu: (() -> Void)? { get set }
    
    func removeBackButtonItem()
        
    func makeSideMenuButton()
    
    @objc func toggleSideMenu()
}

class JoeyPanelViewController: UIViewController, SidePanelControl {
    
    var clickSideMenu: (() -> Void)?
    
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
    
    @objc func toggleSideMenu() {
        
        clickSideMenu?()
        
    }
    
    func removeBackButtonItem() {
        
        navigationItem.leftBarButtonItem = nil
        
        navigationItem.hidesBackButton = true
    }
    
    func setBarAppearance(title: SidePanel) {
        
        navigationItem.setBarAppearance(
            with: .cardViewBlue,
            titleTextAttrs: UINavigationItem.titleAttributes,
            title: title.rawValue
        )
        
    }
    
    func makeSideMenuButton() {
        
        let button = UIButton.makeButton(.rightBarButtonItem(image: ImageConstant.list))
        
        button.addTarget(self, action: #selector(toggleSideMenu), for: .touchDown)
        
        let sideMenuButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = sideMenuButton
        
    }
}
