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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.registerCell(FavoriteTableViewCell.identifierName)
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
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
