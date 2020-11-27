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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNav()
    }
    
    @objc func showList() {
        let categoryViewController = CategoryViewController()
        
        present(categoryViewController, animated: true)
    }
}

private extension SearchPageViewController {
    func setup() {
        searchBarContainerView.backgroundColor = .searchBarGreen
        
        searchBarContainerView.setCorner(radius: 10.0)
        
        cancelButton.setTitleColor(.white, for: .normal)
    }
    
    func setupNav() {
        guard let navigationController = self.navigationController else { return }
        
        let barAppearance = UINavigationBarAppearance()
        
        barAppearance.backgroundColor = .darkGreen
        
        navigationItem.standardAppearance = barAppearance
            
        let rightButtonItem = UIBarButtonItem(image: UIImage.matrix, style: .plain, target: self, action: #selector(showList))
        
        navigationItem.rightBarButtonItem = rightButtonItem
        
        navigationItem.title = "全部"
            
        navigationController.navigationBar.tintColor = .white
    }
    
    func showCategoryView() {
//        let blackView
    }
}
