//
//  RankViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit

class RankViewController: JoeyPanelViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: RankViewModel?
    
    init(viewModel: RankViewModel = .init()) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        
        fetchData(at: sender.selectedSegmentIndex)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(animationView)
        
        setupSegmentControl()
                
        setupTableView()
        
        setupNavigationController()
        
        viewModelBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        fetchData(at: segmentControl.selectedSegmentIndex)
        
    }
    
    func showList() {
        
        let categoryViewController = CategoryViewController()
        
        categoryViewController.delegate = self
        
        present(categoryViewController, animated: true)
    }
}

extension RankViewController: CategoryDelegate {
    
    func confirmSelection(_ selectedCategory: Category) {
       
        viewModel?.getCategory(selectedCategory)

    }
    
    func cancelSelection() {
        
        viewModel?.getCategory(.all)
        
    }
}

private extension RankViewController {
    
    func setupSegmentControl() {
        segmentControl.selectedSegmentTintColor = .homepageDarkBlue
        
        segmentControl.backgroundColor = .disableBackgroundBlue
        
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "PingFang SC", size: 18)!
        ]
        
        segmentControl.setTitleTextAttributes(titleAttributes, for: .normal)
    }
    
    func setupTableView() {
        
        tableView.registerCell(RankTableViewCell.identifierName)
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
    }
    
    func setupNavigationController() {
        
        removeBackButtonItem()
        
        setBarAppearance(title: "排行榜")
        
        makeSideMenuButton()
        
    }
    
    func viewModelBinding() {
        
        viewModel?.updateData = { [weak self] in
            
            self?.animationView.removeFromSuperview()
            
            self?.tableView.reloadData()
            
        }
        
    }
}

extension RankViewController {
    
    func fetchData(at index: Int) {
                
        switch  index {
        case 0:
            viewModel?.fetchData(sortedBy: .views)
        case 1:
            viewModel?.fetchData(sortedBy: .time)
        case 2:
            showList()
        default:
            break
        }
        
    }
    
}

extension RankViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        guard let viewModel = viewModel else { return }
        
        if viewModel.wordViewModels.value.indices.contains(indexPath.row) {
            
            let word = viewModel.wordViewModels.value[indexPath.row]
            
            let definitionVC = DefinitionViewController(identifierNumber: word.identifier, word: word.title, category: word.category)
            
            self.navigationItem.backButtonTitle = ""
            
            self.navigationController?.pushViewController(definitionVC, animated: true)
            
        }
    }
}

extension RankViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.top5WordList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: RankTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        guard let viewModel = viewModel else { return cell }
        
        let rank = viewModel.rankList[indexPath.row]
        
        let color = rank.makeColor()
        
        let word = viewModel.top5WordList[indexPath.row]
            
            cell.renderUI(boardColor: color, title: word)
            
            switch rank {
            
            case .top:
                cell.layoutSubviews()
                
                cell.makeCrown()
            default:
                break
        }
        
        return cell
    }
}
