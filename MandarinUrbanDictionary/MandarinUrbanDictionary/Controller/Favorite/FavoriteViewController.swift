//
//  FavoriteViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class FavoriteViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIStackView!
    
    @IBOutlet weak var deleteAllButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    let viewModel: FavoriteViewModel = .init()
    
    private lazy var editButton: UIBarButtonItem = {
       
        let editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(toggleEditMode))
        
        return editButton
    }()
    
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
        
        binding()
    }
    
    func setNavigationBarTitle(title: String) {
        
        navigationTitle = title
        
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        
        viewModel.tapDelete()
        
    }
    
    @objc func toggleEditMode() {
        
        tableView.isEditing.toggle()
        
        editButton.title = tableView.isEditing ? "Done" : "Edit"
    }
}

private extension FavoriteViewController {
   
    func setup() {
        
        view.backgroundColor = .cardViewBlue
        
        viewModel.makeMockData()
        
    }
    
    func setupTableView() {
        
        tableView.registerCell(FavoriteTableViewCell.identifierName)
        
        tableView.separatorStyle = .none
        
        tableView.allowsMultipleSelection = true
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
        tableView.delegate = self
        
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        
        removeBackButtonItem()
        
        makeSideMenuButton()
        
        makeRightButton()
        
    }
    
    func makeRightButton() {
        
        navigationItem.rightBarButtonItem = editButton
        
    }
    
    func binding() {
        
        viewModel.fetchData = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.removeData = { [weak self] (index) in
            self?.tableView.beginUpdates()
            
            self?.viewModel.mockData.remove(at: index)
            
            self?.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            
            self?.tableView.endUpdates()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(at: indexPath)
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.mockData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifierName, for: indexPath)
        
        let data = viewModel.mockData[indexPath.row].instance()
        
        if let favoriteCell = cell as? FavoriteTableViewCell {
            
            favoriteCell.renderUI(word: data.name, tag: data.image)
            
            cell = favoriteCell
        }
        
        return cell
    }
}
