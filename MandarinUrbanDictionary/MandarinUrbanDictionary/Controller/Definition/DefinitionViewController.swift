//
//  DefinitionViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

class DefinitionViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = DefinitionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupNav()
        setupTableView()
        binding()
    }
}

private extension DefinitionViewController {
    
    func binding() {
        viewModel.updateData = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func setup() {
        viewModel.makeMockData(amount: 3)
    }
    
    func setupNav() {
        navigationItem.setBarAppearance(with: .homepageDarkBlue)
    }
    
    func setupTableView() {
        tableView.registerHeaderFooterCell(DefinitionHeaderView.identifierName)
        tableView.registerCell(DefinitionTableViewCell.identifierName)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = .separatorlineBlue
    }
}

extension DefinitionViewController: UITabBarDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DefinitionHeaderView.identifierName) as? DefinitionHeaderView {
            let headerBackgroundView = UIView()
            headerBackgroundView.backgroundColor = .searchBarBlue
    
            headerView.backgroundView = headerBackgroundView
            
            headerView.wordLabel.text = "The Dodo"
            
          return headerView
        }
        
        return nil
    }
}

extension DefinitionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.definitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: DefinitionTableViewCell.identifierName, for: indexPath)
        
        let definition = viewModel.definitions[indexPath.row]
        
        if let definitionTableViewCell = cell as? DefinitionTableViewCell {
            
            let rankString = viewModel.convertRank(with: indexPath.row)
            
            definitionTableViewCell.renderUI(
                rank: rankString,
                isLiked: false,
                amountOfLike: definition.like.count,
                amountOfDislike: definition.dislike.count,
                isReported: false,
                content: definition.content
            )
            
            cell = definitionTableViewCell
        }
        
        return cell
    }
}
