//
//  FavoriteViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let mockData = Category.allCases
    
    var clickSideMenu: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupTableView()
        setupNavigationController()
    }
    
    @objc func toggleSideMenu() {
        clickSideMenu?()
    }
}

private extension FavoriteViewController {
    func setup() {
        view.backgroundColor = .cardViewBlue
    }
    
    func setupTableView() {
        tableView.registerCell(FavoriteTableViewCell.identifierName)
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "PingFang SC", size: 28)!
        ]
        
        self.navigationItem.setBarAppearance(with: .cardViewBlue, titleTextAttrs: attrs, title: "Favorite")
        
        let sideMenuButton = UIBarButtonItem(image: UIImage.list, style: .plain, target: self, action: #selector(toggleSideMenu))
        
        self.navigationItem.leftBarButtonItem = sideMenuButton
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifierName, for: indexPath)
        
        let data = mockData[indexPath.row].makeIcon()
        
        if let favoriteCell = cell as? FavoriteTableViewCell {
            favoriteCell.renderUI(word: data.name)
            
            cell = favoriteCell
        }
        
        return cell
    }
}
