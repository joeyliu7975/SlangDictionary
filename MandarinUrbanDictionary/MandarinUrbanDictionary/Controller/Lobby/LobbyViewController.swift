//
//  LobbyViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
//    weak var delegate: CenterViewControllerDelegate?
    
    private let viewModel: HomePageViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        
        binding()
    }

    func setupTableView() {
        tableView.registerCell(HomepageTableViewCell.reusableIdentifier)
        tableView.registerCell(MiniRankTableViewCell.reusableIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.fetchData(in: .user)
    }
    
    func binding() {
        
        viewModel.userViewModels.bind { [weak self] (_) in
            
            self?.tableView.reloadData()
            
        }
    }
}

extension LobbyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.75
    }
}

extension LobbyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.carouselList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let cellType = viewModel.carouselList[indexPath.row]
        
        let item = viewModel.userViewModels.value[indexPath.row]
        
        switch cellType {
        case .newestWord:
            cell = tableView.dequeueReusableCell(withIdentifier: HomepageTableViewCell.reusableIdentifier, for: indexPath)
            
            guard let homepageCell = cell as? HomepageTableViewCell else { return cell }
            
            homepageCell.renderUI(word: item.name, definition: item.identifier)
            
            cell = homepageCell
            
        case .mostViewedWord:
            cell = tableView.dequeueReusableCell(withIdentifier: MiniRankTableViewCell.reusableIdentifier, for: indexPath)
            
            guard let viewedCell = cell as? MiniRankTableViewCell else { return cell }
            
            viewedCell.assignViewModel(viewModel)
            
            cell = viewedCell
            
        case .dailyWord:
            cell = tableView.dequeueReusableCell(withIdentifier: HomepageTableViewCell.reusableIdentifier, for: indexPath)
            
            guard let homepageCell = cell as? HomepageTableViewCell else { return cell }
            
            homepageCell.renderUI(word: item.name, definition: item.identifier)
            
            cell = homepageCell
        }
        
//        cell = tableView.dequeueReusableCell(withIdentifier: HomepageTableViewCell.reusableIdentifier, for: indexPath)
//
//        let item = viewModel.userViewModels.value[indexPath.row]
//
//        if let cardCell = cell as? HomepageTableViewCell {
//            cardCell.renderUI(word: item.name, definition: item.identifier)
//
//            cell = cardCell
//
//        }
        
        return cell
    }
}
