//
//  SearchPageViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit
import Hero

class SearchPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchBar: UISearchBar = {

        let width = UIScreen.main.bounds.width - 90

        let searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width, height: 20))

        searchBar.setTextColor(.homepageDarkBlue, cursorColor: .homepageDarkBlue)

        return searchBar

    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        
        cancelButton.setTitle("取消", for: .normal)
        
        cancelButton.setTitleColor(.white, for: .normal)
        
        return cancelButton
    }()
    
    lazy var coverView: UIView = {
       
        let myView = UIView(frame: tableView.bounds)
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        
        myView.backgroundColor = .white
        
        return myView
    }()
    
    lazy var noResultLabel: UILabel = {
       
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
                        
        label.textAlignment = .center
                
        return label
    }()
    
    let viewModel: SearchViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        setupTableView()
        
        setupNav()
        
        setupNoResultView()
        
        viewModelBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchBar.resignFirstResponder()
    }

    @objc func cancelSearch(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }
}

private extension SearchPageViewController {
    
    func setup() {
            
        cancelButton.setTitleColor(.white, for: .normal)
                
        searchBar.setTextColor(.black, cursorColor: .separatorlineBlue)
        
        searchBar.setClearButton(color: .lightGray)
        
        searchBar.setSearchIcon(color: .lightGray)
        
        searchBar.becomeFirstResponder()
        
        searchBar.returnKeyType = .default
        
        searchBar.delegate = self
        
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        tableView.registerCell(SearchTableViewCell.identifierName)
    }
    
    func setupNav() {
        
        guard let navigationController = self.navigationController else { return }
            
        navigationController.navigationBar.tintColor = .white
        
        cancelButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        
        let rightButtonItem = UIBarButtonItem(customView: cancelButton)
        
        navigationItem.rightBarButtonItem = rightButtonItem
            
        navigationItem.backBarButtonItem = UIBarButtonItem()
        
        navigationItem.setBarAppearance(with: .homepageDarkBlue)
    }
    
    func setupNoResultView() {
        
        view.insertSubview(coverView, aboveSubview: tableView)
        
        coverView.addSubview(noResultLabel)
        
        NSLayoutConstraint.activate([
                coverView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
                coverView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
                coverView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
                coverView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
                noResultLabel.centerYAnchor.constraint(equalTo: coverView.centerYAnchor, constant: -100),
                noResultLabel.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                noResultLabel.heightAnchor.constraint(equalToConstant: 24),
                noResultLabel.widthAnchor.constraint(equalToConstant: 150)
            ])
    }
    
    func viewModelBinding() {
        
        viewModel.updateTitle = { [weak self] (title) in
            
            self?.updateBarTitle(title)
            
        }
        
        viewModel.result.bind { [weak self] (result) in
            
            guard let keyword = self?.viewModel.keyword else {
                return
            }
            
            self?.setupNoResultView()
            
            guard let result = self?.viewModel.showResult(keyword: keyword, result: result) else { return }
            
            switch result {
            case .noKeyword:
                self?.noResultLabel.text = ""
            case .noMatchFound:
                self?.noResultLabel.text = "No Match Found"
            case .hasResult:
                self?.coverView.removeFromSuperview()
            }

            self?.tableView?.reloadData()
            
        }
        
    }
    
    func updateBarTitle(_ title: String) {
        
        navigationItem.setBarAppearance(with: .homepageDarkBlue, titleTextAttrs: UINavigationItem.titleAttributes, title: title)
        
    }
        
}

extension SearchPageViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        
        viewModel.clearSearchBar()
        
        if !searchText.isEmpty {
            
            viewModel.search(keyword: searchText)
        
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let validString = NSCharacterSet.searchBarValidString

        if (searchBar.textInputMode?.primaryLanguage == "emoji") || searchBar.textInputMode?.primaryLanguage == nil {
            return false
        }
        
        if let _ = text.rangeOfCharacter(from: validString as CharacterSet) {
            
            return false
        }
        
        return true
    }
}

extension SearchPageViewController: DefinitionViewControllerDelegate {
    func dismissSearchViewController() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension SearchPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedWord = viewModel.result.value[indexPath.row]
        
        viewModel.updateViewsOfWord(at: indexPath.row)
        
        let definitionViewController: DefinitionViewController =
            .init(identifierNumber: selectedWord.identifier, word: selectedWord.title, category: selectedWord.category)
        
        definitionViewController.delegate = self
        
        guard let navigationController = self.navigationController else { return }
        
        navigationController.pushViewController(definitionViewController, animated: true)
    }
}

extension SearchPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.result.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchTableViewCell = tableView.makeCell(indexPath: indexPath)
            
        let word = viewModel.result.value[indexPath.row]
            
        cell.renderUI(word.title, keyword: viewModel.keyword, category: word.category)
    
        return cell
    }
}
