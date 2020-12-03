//
//  QuizViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var imageViewTopAnchor: NSLayoutConstraint!
    
    var clickSideMenu: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
        setupNavigationController()
    }
    
    @objc func toggleSideMenu() {
        clickSideMenu?()
    }
}

private extension QuizViewController {
    func setup() {
        if let barHeight = navigationController?.navigationBar.frame.height {
            
            let topAnchor = UIScreen.main.bounds.height - barHeight
            
            imageViewTopAnchor.constant = topAnchor * 0.16
        }
    }
    
    func setupNavigationController() {
        
        removeBackButtonItem()
        
        let sideMenuButton = UIBarButtonItem(image: UIImage(named: JoeyImage.list), style: .plain, target: self, action: #selector(toggleSideMenu))
        
        navigationItem.leftBarButtonItem = sideMenuButton
                
        navigationItem.setBarAppearance(
            with: .cardViewBlue,
            titleTextAttrs: UINavigationItem.titleAttributes,
            title: "Favorite"
        )
    }
    
    func removeBackButtonItem() {
        
        navigationItem.leftBarButtonItem = nil
        
        navigationItem.hidesBackButton = true
    }
}
