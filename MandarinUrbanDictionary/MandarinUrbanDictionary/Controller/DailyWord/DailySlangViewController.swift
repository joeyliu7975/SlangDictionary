//
//  WordOfTheDayViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/23/20.
//

import UIKit

class DailySlangViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupNavigationController()
    }

    func setup() {
        
    }
   

    func setupNavigationController() {
        
        setBarAppearance(title: "每日一字")
        
        removeBackButtonItem()
        
        makeSideMenuButton()
        
    }
}
