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
    
    var viewModel: FavoriteViewModel?
    
    private lazy var editButton: UIBarButtonItem = {
       
        let editButton = UIBarButtonItem(title: "編輯", style: .done, target: self, action: #selector(toggleEditMode))
        
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
        
        viewModelBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewModel?.getUserFavoriteWordsList()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        viewModel?.reset()
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        
        tableView.setEditing(editing, animated: true)
    }
    
    func setNavigationBarTitle(title: String) {
        
        navigationTitle = title
        
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        
        viewModel?.tapDelete()
        
    }
    
    @IBAction func tapDeleteAll(_ sender: UIButton) {
        
        showAlert()
        
    }
    
    @objc func toggleEditMode() {
        
        viewModel?.isEditing.toggle()
    
    }
}

private extension FavoriteViewController {
   
    func setup() {
        
        view.backgroundColor = .cardViewBlue
        
        guard let title = navigationItem.title else { return }
        
        viewModel = FavoriteViewModel(title: title)
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
    
    func showAlert() {

        let presenter = FavoritePresenter(
            title: "移除全部",
            message: "請問要移除所有內容？",
            cancelTitle: "取消",
            confirmTitle: "刪除全部") { [unowned self] (outcome) in
            switch outcome {
            case .confirm:
                self.viewModel?.tapDeleteAll()
                self.viewModel?.isEditing.toggle()
            case .cancel:
                break
            }
        }

        presenter.present(in: self)
    }
    
    func viewModelBinding() {
        
        viewModel?.favoriteViewModels.bind { [weak self] (_) in
            
            guard let viewModel = self?.viewModel else { return }
            
            switch viewModel.isEditing {
            case true:
                
                break
                
            case false:
                
                self?.tableView.reloadData()
                            
            }
        }
        
        viewModel?.removeData = { [weak self] (indexs) in
            
            self?.tableView.beginUpdates()
            
            indexs.sorted { $0 > $1 }.forEach { self?.viewModel?.favoriteViewModels.value.remove(at: $0)
            }
            
            let indexPaths: [IndexPath] = indexs.sorted { $0 > $1 }.map { IndexPath(row: $0, section: 0) }
            
            self?.tableView.deleteRows(at: indexPaths, with: .top)
            
            self?.tableView.endUpdates()
        }
        
        viewModel?.toggleEditMode = { [weak self] (isEditing) in
            
            self?.tableView.isEditing = isEditing
            
            self?.deleteViewHeighConstraint.constant = isEditing ? 50 : 0
            
            self?.editButton.title = isEditing ? "完成" : "編輯"
            
            switch isEditing {
            case true:
                break
            case false:
                self?.viewModel?.removeSelections()
            }
        }
        
        viewModel?.deleteButtonEnable = { [weak self] (isEnable) in
            
            self?.deleteButton.isEnabled = isEnable
            
            switch isEnable {
            case true:
                self?.deleteButton.setTitleColor(.systemPink, for: .normal)
            case false:
                self?.deleteButton.setTitleColor(.lightGray, for: .normal)
            }
            
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView.isEditing {
        case true:
            viewModel?.select(at: indexPath)
        case false:
            
            guard let viewModel = self.viewModel else { return }
            
            let word = viewModel.favoriteViewModels.value[indexPath.row]
            
            let definitionViewController = DefinitionViewController(identifierNumber: word.identifier, word: word.title, category: word.category)
            
            navigationController?.pushViewController(definitionViewController, animated: true)
        }
        
        return
//        viewModel?.select(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        viewModel?.select(at: indexPath)
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel?.favoriteViewModels.value.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FavoriteTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        guard let viewModel = viewModel else { return cell }

        let word = viewModel.favoriteViewModels.value[indexPath.row]
            
        cell.renderUI(word: word.title, tag: word.category)
        
        return cell
    }
}
