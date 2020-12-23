//
//  DailyWordViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/23/20.
//

import UIKit

class DailyWordViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTableView()
        
        setupNavigationController()
    }
}

private extension DailyWordViewController {
    func setupTableView() {
        
        tableView.registerCell(DailyTableViewCell.reusableIdentifier)
        
        tableView.backgroundColor = .cardViewBlue
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
    }
    
    func setupNavigationController() {
        
        setBarAppearance(title: "每日一字")
        
        removeBackButtonItem()
        
        makeSideMenuButton()
        
    }
}

extension DailyWordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

extension DailyWordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DailyTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        return cell
    }
}
