//
//  SidePanelHeaderFooterView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

class SidePanelHeaderFooterView: UITableViewHeaderFooterView {
    
    static let identifierName = String(describing: SidePanelHeaderFooterView.self)
    @IBOutlet weak var logoImageViewLeadingAnchor: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
}
