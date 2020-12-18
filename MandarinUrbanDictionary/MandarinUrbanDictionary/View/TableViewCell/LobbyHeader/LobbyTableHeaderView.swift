//
//  LobbyTableHeaderFooterView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/12/20.
//

import UIKit

protocol LobbyHeaderDelegate: class {
    func clickSearch()
}

class LobbyTableHeaderView: UITableViewHeaderFooterView {

    static let reusableIdentifier = String(describing: LobbyTableHeaderView.self)
    
    @IBOutlet weak var searchButton: SearchButton!
    
    weak var delegate: LobbyHeaderDelegate?
    
    @IBAction func clickSearch(_ sender: SearchButton) {
        delegate?.clickSearch()
    }
}
