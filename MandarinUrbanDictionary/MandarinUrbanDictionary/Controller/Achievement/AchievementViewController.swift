//
//  UserViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import UIKit

class AchievementViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
        
    let viewModel: UserViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()

        setupTableView()
        
        setupNavigationController()
        
        viewModelBinding()
    }

}

private extension AchievementViewController {
    
    func setup() {
        
        viewModel.fetchUserStatus()
        
    }
    
    func setupTableView() {
        tableView.registerCell(AchievementTableViewCell.reusableIdentifier)
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        
        removeBackButtonItem()
        
        setBarAppearance(title: "成就")
        
        makeSideMenuButton()
        
    }
    
    func viewModelBinding() {
        
        viewModel.currentUser.bind { [weak self] (users) in
            
            if let user = users.first {
                
                let postProcess = self?.viewModel.getProcess(at: .post, currentStage: user.postChallenge)
                
                let viewProcess = self?.viewModel.getProcess(at: .view, currentStage: user.viewChallenge)
                
                let favoriteProcess = self?.viewModel.getProcess(at: .like, currentStage: user.likeChallenge)
                
                // Save user's favorite list at local side and check whenever user add a new ones
                
                if user.likeChallenge == 0 {
                    UserDefaults.standard.set(user.favorites, forKey: "userFavorites")
                }
                
                self?.viewModel.processList[.post] = postProcess
                
                self?.viewModel.processList[.view] = viewProcess
                
                self?.viewModel.processList[.like] = favoriteProcess
                
                self?.tableView.reloadData()
            }
            
        }
    }
    
}

extension AchievementViewController: AchievementTableViewCellDelegate {
    
    func startChallenge(_ cell: UITableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let type = viewModel.challenges[indexPath.row]
        
        guard let challenge = viewModel.processList[type] else { return }
        
        viewModel.startChallenge(challenge: challenge.challenge) { [weak self] in
            
            self?.viewModel.fetchUserStatus()
        }
        
    }
    
}

extension AchievementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UIScreen.main.bounds.height * 0.5
    }
}

extension AchievementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewModel.processList.isEmpty {
        case true:
            return 0
        case false:
            return viewModel.challenges.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AchievementTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        let challengeType = viewModel.challenges[indexPath.row]
        
        cell.delegate = self
        
        // ProgressBar default settings
        
        let progressBar = viewModel.getProgressBar(challengeType)
        
        cell.setup(title: progressBar.title, barColor: progressBar.color)
        
        guard let process = viewModel.processList[challengeType] else { return cell }
        
        // Calculate ProgressBar Percentage with Process
        
        if !process.hasDrawed {
            cell.drawDiscoveryTracker()
            
            cell.renderChallengeLabel(process.stage, percentage: process.currentStage * 10)
            
            process.drawed()
        }
        
        return cell
    }

}
