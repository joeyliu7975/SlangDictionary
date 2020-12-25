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
    
    func setBarAppearance(title: String)
        
    func makeSideMenuButton()
    
    @objc func toggleSideMenu()
}

class JoeyPanelViewController: UIViewController, SidePanelControl {
    
    var clickSideMenu: (() -> Void)?
    
    lazy var animationView: UIView = {
        
       var animationView = AnimationView()
        
        animationView = .init(name: "loading-spinner")
        
        animationView.frame = self.navigationController?.view.bounds ?? view.bounds
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.animationSpeed = 0.75
        
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
    
    func setBarAppearance(title: String) {
        
        navigationItem.setBarAppearance(
            with: .cardViewBlue,
            titleTextAttrs: UINavigationItem.titleAttributes,
            title: title
        )
        
    }
    
    func makeSideMenuButton() {
        
        let button = UIButton()
        
        button.imageView?.contentMode = .scaleToFill
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(UIImage(named: ImageConstant.list), for: .normal)
        
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        button.addTarget(self, action: #selector(toggleSideMenu), for: .touchDown)
        
        let sideMenuButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = sideMenuButton
        
    }
}
