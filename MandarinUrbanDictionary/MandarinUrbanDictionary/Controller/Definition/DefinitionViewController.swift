//
//  DefinitionViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

class DefinitionViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DefinitionViewModel?
    
    init(identifierNumber: String) {
        viewModel = DefinitionViewModel(id: identifierNumber)
        viewModel?.listen()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNav()
        
        setupTableView()
        
        binding()
    }
}

private extension DefinitionViewController {
    
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
    
    func binding() {
        
        viewModel?.definitionViewModels.bind { [weak self] (_) in
            
            self?.tableView.reloadData()
            
        }
        
    }
}

extension DefinitionViewController: DefinitionHeaderDelegate {
    
    func toggleFavorite() {
        
        viewModel?.isLike.toggle()
        
    }
    
    func writeNewDefinition() { }
}

extension DefinitionViewController: DefinitionTableViewCellDelegate {
    
    func report(_ cell: DefinitionTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
            
            let index = indexPath.row
            
//            let reportedDefinition = viewModel.definitions[index]
            
            self.popAlert(.actionSheet({
                
                let reportVC = ReportViewController()
                
                reportVC.delegate = self
                
                let navVC = UINavigationController(rootViewController: reportVC)
                
                self.present(navVC, animated: true)
            })
            )
        }
    }
}

extension DefinitionViewController: ReportDelegate {
   
    func sendReport(_ isReport: Bool) {
        
        switch isReport {
        
        case true:
        // Do something
        break
        case false:
        // Do nothing
        break
        }
        
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
            
            guard let islike = viewModel?.isLike else { return nil }
            
            let headerBackgroundView = UIView()
            
            headerView.delegate = self
                        
            headerBackgroundView.backgroundColor = .searchBarBlue
    
            headerView.backgroundView = headerBackgroundView
            
            headerView.wordLabel.text = "The Dodo"
            
            headerView.setFavorite(islike)
            
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: DefinitionTableViewCell.identifierName, for: indexPath)
        
//        let definition = viewModel.definitions[indexPath.row]
        
        let rankString = viewModel?.convertRank(with: indexPath.row)
        
        if let definitionTableViewCell = cell as? DefinitionTableViewCell {
            
            cell = definitionTableViewCell
            
            definitionTableViewCell.delegate = self
            
//            definitionTableViewCell.renderUI(
//                rank: rankString,
//                isLiked: false,
//                amountOfLike: definition.like.count,
//                amountOfDislike: definition.dislike.count,
//                isReported: false,
//                content: definition.content
//            )
        }
        
        return cell
    }
}
