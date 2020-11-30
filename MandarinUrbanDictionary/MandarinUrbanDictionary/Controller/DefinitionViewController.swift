//
//  DefinitionViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

class DefinitionViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNav()
        setupTableView()
    }
}

private extension DefinitionViewController {
    
    func setupNav() {
        navigationItem.setBarAppearance(with: .homepageDarkBlue)
    }
    
    func setupTableView() {
        tableView.registerHeaderFooterCell(String(describing: DefinitionHeaderView.self))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension DefinitionViewController: UITabBarDelegate {
    
}

extension DefinitionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DefinitionHeaderView.identifierName) as? DefinitionHeaderView {
            let headerBackgroundView = UIView()
            headerBackgroundView.backgroundColor = .homepageDarkBlue
    
            headerView.backgroundView = headerBackgroundView
            
            headerView.wordLabel.text = "爆速開發"
            
          return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
}
