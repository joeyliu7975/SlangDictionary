//
//  UserViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import UIKit

class UserViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
        
    private let viewModel: UserViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
        setupNavigationController()
    }
    
    func setupTableView() {
        tableView.registerCell(UserTableViewCell.reusableIdentifier)
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        
        removeBackButtonItem()
        
        setBarAppearance(title: "用戶")
        
        makeSideMenuButton()
        
    }
}

extension UserViewController: UserTableViewCellDelegate {
    
    func startChallenge(_ cell: UITableViewCell) {
        
        guard let index = tableView.indexPath(for: cell) else { return }
        
        print(index)
    }
    
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.5
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        let challenge = viewModel.challenges[indexPath.row]
        
        let title = viewModel.getTitle(challenge)
        
        cell.delegate = self
        
        cell.renderUI(title: title)
        
        cell.drawDiscoveryTracker()
                
        return cell
    }

}
