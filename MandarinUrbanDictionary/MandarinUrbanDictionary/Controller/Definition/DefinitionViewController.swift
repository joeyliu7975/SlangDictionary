//
//  DefinitionViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

protocol DefinitionViewControllerDelegate: class {
    func dismissSearchViewController()
}

class DefinitionViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DefinitionViewModel?
    
    weak var delegate: DefinitionViewControllerDelegate?
    
    init(identifierNumber: String, word: String, category: String) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel = DefinitionViewModel(id: identifierNumber, word: word, category: category)
        
        viewModel?.renewRecentSearch { [weak self] in
            self?.viewModel?.addToRecentSearch()
            self?.viewModel?.discoverWord()
        }
        
        searchBar.text = word
        
        viewModel?.listen()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchBar: UISearchBar = {

        let width = UIScreen.main.bounds.width - 20

        let searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 5, y: 0, width: width, height: 20))

        searchBar.setTextColor(.black, cursorColor: .homepageDarkBlue)

        return searchBar

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        setupNav()
        
        setupTableView()
        
        viewModelBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }
}

private extension DefinitionViewController {
    
    func setup() {
        
        searchBar.delegate = self
        
        viewModel?.checkFavorite(completion: { [weak self] (isFavorite) in
            
            self?.viewModel?.isFavorite = isFavorite
            
        })
        
    }
    
    func setupNav() {
        
        navigationItem.setBarAppearance(with: .homepageDarkBlue)
                
        navigationItem.backButtonTitle = ""
        
        navigationItem.backBarButtonItem = UIBarButtonItem()
        
        let leftButtonItem = UIBarButtonItem(customView: searchBar)
        
        navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    func setupTableView() {
        
        tableView.registerHeaderFooterCell(DefinitionHeaderView.identifierName)
        
        tableView.registerCell(DefinitionTableViewCell.identifierName)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = UIView()
    }
    
    func viewModelBinding() {
        
        viewModel?.definitionViewModels.bind { [weak self] (_) in
            
            self?.tableView.reloadData()
            
        }
        
        viewModel?.updateData = { [weak self] in
            
            self?.tableView.reloadData()
            
        }
    }
    
    func showAlert() {
        
        let presenter = ReportPresenter(
            title: "檢舉",
            message: "請問你想要檢舉此則解釋",
            cancelTitle: "取消",
            reportTitle: "檢舉") { (outcome) in
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
    
    func clickReadOut() {
        if let word = viewModel?.word {
            viewModel?.siriRead(word)
        }
    }
    
    func clickBackButton() {
        
        if let _ = navigationController?.rootViewController as? LobbyViewController {
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        delegate?.dismissSearchViewController()
    }
    
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
        
        if let _ = tableView.indexPath(for: cell) {
            
            //            let index = indexPath.row
            
            //            let reportedDefinition = viewModel.definitions[index]
            
            showAlert()
        }
    }
    
    func tapSearchBar() {
        
        let searchViewController = SearchPageViewController()
        
        let navController = UINavigationController(rootViewController: searchViewController)
        
        navController.present(self)
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

extension DefinitionViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        tapSearchBar()
        
        return false
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
            
            headerView.renderUI(category: viewModel.category, word: viewModel.word)
            
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
        
        let cell: DefinitionTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        guard
            let definition = viewModel?.definitionViewModels.value[indexPath.row],
            let rankString = viewModel?.convertRank(with: indexPath.row),
            let uid = UserDefaults.standard.value(forKey: "uid") as? String
        else { return cell }
            
            cell.delegate = self
            
            let opinion = definition.showUserOpinion(uid)
            
        cell.renderUI(
                rank: rankString,
                isLiked: opinion,
                amountOfLike: definition.like.count,
                amountOfDislike: definition.dislike.count,
                isReported: false,
                content: definition.content
            )
        
        return cell
    }
}
