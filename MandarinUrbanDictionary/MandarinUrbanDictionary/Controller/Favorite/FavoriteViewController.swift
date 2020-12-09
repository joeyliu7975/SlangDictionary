//
//  FavoriteViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class FavoriteViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var deleteAllButton: UIButton!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var deleteViewHeighConstraint: NSLayoutConstraint!
    
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        tableView.setEditing(editing, animated: true)
    }
    
    func setNavigationBarTitle(title: String) {
        
        navigationTitle = title
        
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        
        viewModel.tapDelete()
        
    }
    
    @IBAction func tapDeleteAll(_ sender: UIButton) {
        let alert = UIAlertController(title: "Favorite Words", message: "Are you sure you want to delete all favorite words", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Delete All", style: .default) { (action) in
            self.viewModel.tapDeleteAll()
            self.viewModel.isEditing.toggle()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        
        alert.addAction(cancel)
        
        present(alert, animated: true)
        
    }
    
    @objc func toggleEditMode() {
        
        viewModel.isEditing.toggle()
    
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
        
        viewModel.toggleEditMode = { [weak self] (isEditing) in
            
            self?.tableView.isEditing = isEditing
            
            self?.deleteViewHeighConstraint.constant = isEditing ? 50 : 0
            
            self?.editButton.title = isEditing ? "Done" : "Edit"
        }
        
        viewModel.deleteButtonEnable = { [weak self] (isEnable) in
            
            self?.deleteButton.isEnabled = isEnable
            
            switch isEnable {
            case true:
                self?.deleteButton.setTitleColor(.systemPink, for: .normal)
            case false:
                self?.deleteButton.setTitleColor(.lightGray, for: .normal)
            }
            
        }
        
        viewModel.removeAll = { [weak self] in
            
            self?.tableView.reloadData()
            
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
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
