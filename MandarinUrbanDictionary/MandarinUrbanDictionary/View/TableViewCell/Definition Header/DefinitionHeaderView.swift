//
//  DefinitionHeaderView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

final class DefinitionHeaderView: UITableViewHeaderFooterView {
    
    static let identifierName = String(describing: DefinitionHeaderView.self)
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var writeDefinition: UIButton!
}
