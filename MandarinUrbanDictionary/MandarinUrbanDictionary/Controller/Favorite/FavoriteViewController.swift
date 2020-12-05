//
//  FavoriteViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class FavoriteViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let mockData = Category.allCases
    
    var navigationTitle: String? {
        didSet {
            
            guard let title = navigationTitle else { return }
            
            setBarAppearance(title: title)
            
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
        setupTableView()
        
        setupNavigationController()
    }
    
    func setNavigationBarTitle(title: String) {
        
        navigationTitle = title
        
    }
    
    @objc func toggleEditMode() {
        print("Toggle")
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
        
        removeBackButtonItem()
        
        makeSideMenuButton()
        
        makeRightButton()
        
    }
    
    func makeRightButton() {
        
        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(toggleEditMode))
        
        navigationItem.rightBarButtonItem = editButton
        
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
        
        let data = mockData[indexPath.row].instance()
        
        if let favoriteCell = cell as? FavoriteTableViewCell {
            
            favoriteCell.renderUI(word: data.name, tag: data.image)
            
            cell = favoriteCell
        }
        
        return cell
    }
}
