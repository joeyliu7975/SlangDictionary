//
//  UserViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import UIKit

class UserViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let shapeLayer = CAShapeLayer()
    
    private let viewModel: UserViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        setupNavigationController()
    }
    
    func setupTableView() {
        tableView.registerCell(UserTableViewCell.reusableIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        
        removeBackButtonItem()
        
        setBarAppearance(title: "排行榜")
        
        makeSideMenuButton()
        
    }
}

extension UserViewController {
    
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.5
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        cell.renderUI(title: "我的挑戰")
        
        cell.drawDiscoveryTracker()
                
        return cell
    }

}
