//
//  QuizViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit

class QuizViewController: JoeyPanelViewController {

    @IBOutlet weak var imageViewTopAnchor: NSLayoutConstraint!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
        setNavigationController()
        
    }
    
}

private extension QuizViewController {
    
    func setup() {
        
        if let barHeight = navigationController?.navigationBar.frame.height {
            
            let topAnchor = UIScreen.main.bounds.height - barHeight
            
            imageViewTopAnchor.constant = topAnchor * 0.16
        }
    }
    
    func setNavigationController() {
        
        removeBackButtonItem()
        
        setBarAppearance(title: "Quiz")
        
        makeSideMenuButton()
    }
    
}
