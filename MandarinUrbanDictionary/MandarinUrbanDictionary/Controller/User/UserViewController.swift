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
        
        setup()

        setupTableView()
        
        setupNavigationController()
        
        viewModelBinding()
    }

}

private extension UserViewController {
    
    func setup() {
        
        viewModel.fetchUserStatus()
        
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
    
    func viewModelBinding() {
        
        viewModel.currentUser.bind { [weak self] (users) in
            
            if let user = users.first {
                
                let postProcess = self?.viewModel.getProcess(at: .post, currentStage: user.postChallenge)
                
                let viewProcess = self?.viewModel.getProcess(at: .view, currentStage: user.viewChallenge)
                
                let favoriteProcess = self?.viewModel.getProcess(at: .favorite, currentStage: user.favoriteChallenge)
                
                self?.viewModel.processList[.post] = postProcess
                
                self?.viewModel.processList[.view] = viewProcess
                
                self?.viewModel.processList[.favorite] = favoriteProcess
                
                self?.tableView.reloadData()
            }
            
        }
    }
    
}

extension UserViewController: UserTableViewCellDelegate {
    
    func startChallenge(_ cell: UITableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let type = viewModel.challenges[indexPath.row]
        
        guard let challenge = viewModel.processList[type] else { return }
        
        viewModel.startChallenge(challenge: challenge.challenge) { [weak self] in
            
            self?.viewModel.fetchUserStatus()
            
        }
        
    }
    
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.5
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewModel.processList.isEmpty {
        case true:
            return 0
        case false:
            return viewModel.challenges.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UserTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        let challenge = viewModel.challenges[indexPath.row]
        
        guard let process = viewModel.processList[challenge] else { return cell }
        
        let progressBar = viewModel.getProgressBar(challenge)
        
        cell.delegate = self
        
        cell.renderUI(title: progressBar.title, color: progressBar.color)
        
        // Calculate ProgressBar Percentage with Process
        
        let userProcess = viewModel.getProcess(at: process.challenge, currentStage: process.currentStage)
        
        let currentStage = viewModel.getStage(currentStage: userProcess.currentStage)
        
        cell.renderChallengeLabel(currentStage, percentage: userProcess.currentStage * 10)
        
        cell.drawDiscoveryTracker()
                
        return cell
    }

}
