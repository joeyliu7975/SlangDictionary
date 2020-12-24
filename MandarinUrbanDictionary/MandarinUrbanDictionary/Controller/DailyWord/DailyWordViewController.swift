//
//  DailyWordViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/23/20.
//

import UIKit

class DailyWordViewController: JoeyPanelViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: DailyWordViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTableView()
        
        setupNavigationController()
        
        listen()
        
        viewModelBinding()
    }
}

private extension DailyWordViewController {
    
    func setupTableView() {
        
        tableView.registerCell(DailyTableViewCell.reusableIdentifier)
        
        tableView.backgroundColor = .cardViewBlue
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
    }
    
    func setupNavigationController() {
        
        setBarAppearance(title: "每日一字")
        
        removeBackButtonItem()
        
        makeSideMenuButton()
        
    }
    
    func listen() {
        
        viewModel.listen(env: .dailyWorld, orderBy: .dailyTime) { [weak self] (result: Result<[DailyWord], NetworkError>) in
            switch result {
            case .success(let data):
                
                self?.viewModel.handle(data)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func viewModelBinding() {
        
        viewModel.dailyViewModels.bind { [weak self] (_) in
            
            self?.tableView.reloadData()
            
        }
        
    }
}

extension DailyWordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

extension DailyWordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DailyTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        let word = viewModel.dailyViewModels.value[indexPath.row]
        
        cell.dateLabel.text = word.time.timeStampToStringDetail()
        
        cell.wordLabel.text = word.title
        
        return cell
    }
}
