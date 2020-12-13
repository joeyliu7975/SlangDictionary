//
//  SearchPageViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit

class SearchPageViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var searchBarContainerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        binding()
    }
    
    @IBAction func cancelSearch(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func showList() {
        
        let categoryViewController = CategoryViewController()
        
        categoryViewController.delegate = self
        
        present(categoryViewController, animated: true)
    }
}

private extension SearchPageViewController {
    
    // MARK: SearchBar背景色還是改白色，字和其他icon都是黑色，來維持版面的一致性
    
    func setup() {
        
        searchBarContainerView.backgroundColor = .searchBarBlue
            
        cancelButton.setTitleColor(.white, for: .normal)
                
        searchBar.setTextColor(.black, cursorColor: .separatorlineBlue)
        
        searchBar.setClearButton(color: .lightGray)
        
        searchBar.setSearchIcon(color: .lightGray)
        
        searchBar.becomeFirstResponder()
        
        searchBar.returnKeyType = .done
        
        searchBar.delegate = self
        
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.registerCell(SearchTableViewCell.identifierName)
    }
    
    func setupNav() {
        
        guard let navigationController = self.navigationController else { return }
            
        navigationController.navigationBar.tintColor = .white
        
        let rightButtonItem = UIBarButtonItem(
            image: UIImage(named: ImageConstant.matrix),
            style: .plain,
            target: self,
            action: #selector(showList)
        )
        
        navigationItem.rightBarButtonItem = rightButtonItem
            
        navigationItem.backBarButtonItem = UIBarButtonItem()
        
        let title = viewModel.barTitle
        
        updateBarTitle(title)

    }
    
    func setupNoResultView() {
        
        view.insertSubview(coverView, aboveSubview: tableView)
        
        coverView.addSubview(noResultLabel)
        
        NSLayoutConstraint.activate(
            [
                coverView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
                coverView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0),
                coverView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0),
                coverView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            ]
        )
        
        NSLayoutConstraint.activate(
            [
                noResultLabel.centerYAnchor.constraint(equalTo: coverView.centerYAnchor, constant:  -100),
                noResultLabel.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                noResultLabel.heightAnchor.constraint(equalToConstant: 24),
                noResultLabel.widthAnchor.constraint(equalToConstant: 150)
            ]
        )
    }
    
    func binding() {
        
        viewModel.updateTitle = { [weak self] (title) in
            
            self?.updateBarTitle(title)
            
        }
        
        viewModel.result.bind { [weak self] (result) in
            
            self?.setupNoResultView()
            
            if self?.viewModel.keyword == "" {
                
                self?.noResultLabel.text = ""
                
            } else if result.isEmpty {
                
                self?.noResultLabel.text = "No Match Found"
                
            } else {
                
                self?.coverView.removeFromSuperview()
                
            }
            
            self?.tableView?.reloadData()
            
        }
        
    }
    
    func updateBarTitle(_ title: String) {
        
        navigationItem.setBarAppearance(with: .homepageDarkBlue, titleTextAttrs: UINavigationItem.titleAttributes, title: title)
        
    }
        
}

extension SearchPageViewController: CategoryDelegate {
    
    func confirmSelection(_ selectedCategory: Category) {
        
        viewModel.select(category: selectedCategory)
        
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
}

extension SearchPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedWord = viewModel.result.value[indexPath.row]
        
        viewModel.updateViewsOfWord(at: indexPath.row)
        
        let definitionViewController: DefinitionViewController =
            .init(identifierNumber: selectedWord.identifier, word: selectedWord.title)
        
        guard let navigationController = self.navigationController else { return }
        
        navigationController.pushViewController(definitionViewController, animated: true)
    }
}

extension SearchPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.result.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifierName, for: indexPath)
        
        if let searchCell = cell as? SearchTableViewCell {
            
            let word = viewModel.result.value[indexPath.row]
            
            searchCell.renderUI(word.title, keyword: viewModel.keyword)
            
            cell = searchCell
            
        }
    
        return cell
    }
}
