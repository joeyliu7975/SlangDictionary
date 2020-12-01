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
    
    private var selectCategory: Category = .all {
        didSet {
            navigationItem.title = selectCategory.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
        setupNav()
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
    func setup() {
        searchBarContainerView.backgroundColor = .searchBarBlue
            
        cancelButton.setTitleColor(.white, for: .normal)
        
        searchBar.setTextColor(.white, cursorColor: .white)
        
        searchBar.setClearButton(color: .white)
        
        searchBar.setSearchIcon(color: .white)
        
        searchBar.becomeFirstResponder()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNav() {
        guard let navigationController = self.navigationController else { return }
            
        navigationController.navigationBar.tintColor = .white
        
        let rightButtonItem = UIBarButtonItem(image: UIImage.matrix, style: .plain, target: self, action: #selector(showList))
        
        navigationItem.rightBarButtonItem = rightButtonItem
            
        navigationItem.backBarButtonItem = UIBarButtonItem()
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "PingFang SC", size: 28)!
        ]
        
        navigationItem.setBarAppearance(with: .homepageDarkBlue, titleTextAttrs: attrs, title: selectCategory.title)
    }
}

extension SearchPageViewController: CategoryDelegate {
    func confirmSelection(_ selectedCategory: Category) {
        selectCategory = selectedCategory
    }
}

extension SearchPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let definitionViewController = DefinitionViewController()
        
        guard let navigationController = self.navigationController else { return }
        
        navigationController.pushViewController(definitionViewController, animated: true)
    }
}

extension SearchPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
}
