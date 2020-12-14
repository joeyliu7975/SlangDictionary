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
    
    init(identifierNumber: String, word: String) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel = DefinitionViewModel(id: identifierNumber, word: word)
        
        viewModel?.listen()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        setupNav()
        
        setupTableView()
        
        binding()
    }
}

private extension DefinitionViewController {
    
    func setup() {
        
        viewModel?.checkFavorite(completion: { [weak self] (isFavorite) in
            
            self?.viewModel?.isFavorite = isFavorite
            
        })
        
    }
    
    func setupNav() {
        
        navigationItem.setBarAppearance(with: .homepageDarkBlue)
        
        navigationItem.backButtonTitle = ""
        
    }
    
    func setupTableView() {
        
        tableView.registerHeaderFooterCell(DefinitionHeaderView.identifierName)
        
        tableView.registerCell(DefinitionTableViewCell.identifierName)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = UIView()
    }
    
    func binding() {
        
        viewModel?.definitionViewModels.bind { [weak self] (definitions) in
            
            self?.tableView.reloadData()
            
        }
        
        viewModel?.updateData = { [weak self] in
            
            self?.tableView.reloadData()
            
        }
    }
    
    func showAlert() {
        let presenter = ReportPresenter(
            title: "Report",
            message: "Do you want to report this definition",
            cancelTitle: "Cancel",
            reportTitle: "Report") { (outcome) in
            switch outcome {
            case .report:
                // Call API Here...
                let reportVC = ReportViewController()
                
                let nav = UINavigationController(rootViewController: reportVC)
                
                nav.modalPresentationStyle = .fullScreen
                
                nav.modalTransitionStyle = .coverVertical
                
                self.present(nav, animated: true)
            case .cancel:
                break
            }
        }
        
        presenter.present(in: self)
    }
}

extension DefinitionViewController: DefinitionHeaderDelegate {
    
    func toggleFavorite(_ isFavorite: Bool) {
        
        switch isFavorite {
        case true:
            
            guard let viewModel = viewModel else { return }
            
            viewModel.updateFavorites(action: .add) {
                
                print("Add to Favorite Successfully!")
                
            }
        case false:
            
            guard let viewModel = viewModel else { return }
            
            viewModel.updateFavorites(action: .remove) {
                
                print("Remove from Favorite Successfully!")
                
            }
        }
        
    }
    
    func writeNewDefinition() {
        
        guard let viewModel = viewModel else { return }
        
        let newDefVC = NewDefinitionViewController(wordID: viewModel.wordIdentifier)
        
        let nav = UINavigationController(rootViewController: newDefVC)
        
        nav.modalPresentationStyle = .fullScreen
        
        nav.modalTransitionStyle = .flipHorizontal
        
        present(nav, animated: true)
    }
}

extension DefinitionViewController: DefinitionTableViewCellDelegate {
    
    func like(_ cell: DefinitionTableViewCell) {
        guard
            let viewModel = viewModel,
            let index = tableView.indexPath(for: cell),
            let uid = UserDefaults.standard.value(forKey: "uid") as? String
              else { return }
        
        let defID = viewModel.definitionViewModels.value[index.row].identifier
            
        let isLike = viewModel.definitionViewModels.value[index.row].like.contains(uid)
        
        switch isLike {
        case true:
           //取消Like
            viewModel.updateLikes(isLike: !isLike, defID: defID)
            
        case false:
            // Like，取消Dislike
            viewModel.updateLikes(isLike: !isLike, defID: defID)
            
            viewModel.updateDislikes(isDislike: isLike, defID: defID)
            
        }
    }
    
    func dislike(_ cell: DefinitionTableViewCell) {
        guard
            let viewModel = viewModel,
            let index = tableView.indexPath(for: cell),
            let uid = UserDefaults.standard.value(forKey: "uid") as? String
              else { return }
        
        let defID = viewModel.definitionViewModels.value[index.row].identifier
        
        let isDislike = viewModel.definitionViewModels.value[index.row].dislike.contains(uid)
        
        switch isDislike {
        case true:
            //取消Dislike
            viewModel.updateDislikes(isDislike: !isDislike, defID: defID)
            
        case false:
            //取消Like，Dislike
            viewModel.updateDislikes(isDislike: !isDislike, defID: defID)
            
            viewModel.updateLikes(isLike: isDislike, defID: defID)
            
        }
        
    }
    
    
    func report(_ cell: DefinitionTableViewCell) {
        
        if tableView.indexPath(for: cell) != nil {
            
            //            let index = indexPath.row
            
            //            let reportedDefinition = viewModel.definitions[index]
            
            showAlert()
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
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DefinitionHeaderView.identifierName) as? DefinitionHeaderView,
            let viewModel = viewModel {
            
            let headerBackgroundView = UIView()
            
            headerView.delegate = self
            
            headerView.setFavorite(viewModel.isFavorite)
            
            headerBackgroundView.backgroundColor = .searchBarBlue
            
            headerView.backgroundView = headerBackgroundView
            
            headerView.wordLabel.text = viewModel.word
            
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
        return viewModel?.definitionViewModels.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: DefinitionTableViewCell.identifierName, for: indexPath)
        
        guard
            let definition = viewModel?.definitionViewModels.value[indexPath.row],
            let rankString = viewModel?.convertRank(with: indexPath.row),
            let uid = UserDefaults.standard.value(forKey: "uid") as? String
        else { return cell }
        
        if let definitionTableViewCell = cell as? DefinitionTableViewCell {
            
            cell = definitionTableViewCell
            
            definitionTableViewCell.delegate = self
            
            let opinion = definition.showUserOpinion(uid)
            
            definitionTableViewCell.renderUI(
                rank: rankString,
                isLiked: opinion,
                amountOfLike: definition.like.count,
                amountOfDislike: definition.dislike.count,
                isReported: false,
                content: definition.content
            )
        }
        
        return cell
    }
}
