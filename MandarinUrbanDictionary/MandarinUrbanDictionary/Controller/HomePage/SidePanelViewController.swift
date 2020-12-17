//
//  SidePanelViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

class SidePanelViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: SidePanelViewModel = .init()
    
    private var centerPanelExpandedOffset: CGFloat {
        return UIScreen.main.bounds.width * 0.217
    }
    
    weak var delegate: LeftViewControllerDelegate?
    
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedIcon = viewModel.selectItem(index: indexPath.row)
        
        delegate?.navigate(to: selectedIcon)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = UIScreen.main.bounds.height - 80
        
        return height * 0.09
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height * 0.28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SidePanelHeaderFooterView.identifierName)
        
        if let sidePanelView = headerView as? SidePanelHeaderFooterView {
            
            let headerBackgroundView = UIView()
                        
            let width = sidePanelView.logoImageWidth
            
            let logoImageLeadingConstant = (UIScreen.main.bounds.width - width - centerPanelExpandedOffset) / 2
            
            headerBackgroundView.backgroundColor = .sidePanelBlue
    
            sidePanelView.backgroundView = headerBackgroundView
            
            sidePanelView.makeRounded()
            
            sidePanelView.adjustLogoImageWidth()
            
            sidePanelView.logoImageViewLeadingAnchor.constant = logoImageLeadingConstant
            
          return sidePanelView
        }
        
        return nil
    }
}

extension SidePanelViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sidePanelItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SidePanelTableViewCell = tableView.makeCell(indexPath: indexPath)
        
        let item = viewModel.getItem(index: indexPath.row)
        
        cell.renderUI(title: item.name, imageName: item.image)
        
        return cell
    }
}

protocol LeftViewControllerDelegate: class {
    
    func navigate(to page: SidePanel)
    
}
