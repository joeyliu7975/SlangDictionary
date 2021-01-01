//
//  SidePanelHeaderFooterView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

class SidePanelHeaderFooterView: UITableViewHeaderFooterView {
    
    static let reusableIdentifier = String(describing: SidePanelHeaderFooterView.self)
    
    @IBOutlet weak var logoImageViewLeadingAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    var logoImageWidth: CGFloat {
        return UIScreen.main.bounds.width * 0.33
    }
    
    func adjustLogoImageWidth() {
        imageViewWidthConstraint.constant = logoImageWidth
    }
    
    func rounded() {
       logoImageView.setCorner(radius: logoImageWidth / 2)
    }
}
