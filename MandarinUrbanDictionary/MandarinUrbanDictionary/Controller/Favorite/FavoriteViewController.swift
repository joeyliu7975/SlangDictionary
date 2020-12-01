//
//  FavoriteViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FavoriteViewController: UITableViewDelegate { }

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
