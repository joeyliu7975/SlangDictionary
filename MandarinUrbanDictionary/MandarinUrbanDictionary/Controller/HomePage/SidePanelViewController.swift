//
//  SidePanelViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

class SidePanelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SidePanelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }

    private func setupTableView() {
        tableView.registerCell(SidePanelTableViewCell.identifierName)
        tableView.registerHeaderFooterCell(SidePanelHeaderFooterView.identifierName)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .sidePanelBlue
        tableView.separatorStyle = .none
    }
}

extension SidePanelViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 240.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SidePanelHeaderFooterView.identifierName) as? SidePanelHeaderFooterView {
            let headerBackgroundView = UIView()
            
            let width = headerView.logoImageView.frame.width
            
            headerBackgroundView.backgroundColor = .sidePanelBlue
    
            headerView.backgroundView = headerBackgroundView
            
            headerView.logoImageView.setCorner(radius: width / 2)
            
          return headerView
        }
        
        return nil
    }
}

extension SidePanelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sidePanelItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let item = viewModel.getItem(index: indexPath.row)
        
        cell = tableView.dequeueReusableCell(withIdentifier: SidePanelTableViewCell.identifierName, for: indexPath)
        
        if let sidePanelTableViewCell = cell as? SidePanelTableViewCell {
            sidePanelTableViewCell.renderUI(title: item.title, imageName: item.imageName)
            
            cell = sidePanelTableViewCell
        }
        
        return cell
    }
}
