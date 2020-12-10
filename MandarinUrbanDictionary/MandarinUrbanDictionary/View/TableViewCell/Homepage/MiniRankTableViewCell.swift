//
//  MiniRankTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/10/20.
//

import UIKit

class MiniRankTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: MiniRankTableViewCell.self)
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HomePageViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupTableViewCell()
        
        binding()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignViewModel(_ vm: HomePageViewModel) {
        self.viewModel = vm
    }
    
    func setupTableViewCell() {
        tableView.registerCell(RankTableViewCell.identifierName)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func binding() {
        
        viewModel?.userViewModels.bind(listener: { [weak self](_) in
            self?.tableView.reloadData()
        })
        
    }
    
}

extension MiniRankTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cardView.frame.height / 5
    }
}

extension MiniRankTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.userViewModels.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewCell.identifierName, for: indexPath)
        
        if let rankCell = cell as? RankTableViewCell,
           let title = viewModel?.userViewModels.value[indexPath.row].name
           {
            rankCell.renderUI(boardColor: .homepageLightBlue, title: title)
            
            cell = rankCell
        }
        
        
        return cell
    }
}
