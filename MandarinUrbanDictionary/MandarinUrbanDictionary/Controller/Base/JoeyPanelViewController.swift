//
//  JoeyPanelViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit

@objc private protocol SidePanelControl {
    
    var clickSideMenu: (() -> Void)? { get set }
    
    func removeBackButtonItem()
    
    func setBarAppearance(title: String)
        
    func makeSideMenuButton()
    
    @objc func toggleSideMenu()
}

class JoeyPanelViewController: UIViewController, SidePanelControl {
    
    var clickSideMenu: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        let sideMenuButton = UIBarButtonItem(image: UIImage(named: ImageConstant.list), style: .plain, target: self, action: #selector(toggleSideMenu))
        
        navigationItem.leftBarButtonItem = sideMenuButton
        
    }
}
