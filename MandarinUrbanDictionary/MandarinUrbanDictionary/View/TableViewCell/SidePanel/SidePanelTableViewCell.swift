//
//  SidePanelTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

class SidePanelTableViewCell: UITableViewCell {
    
    static let identifierName = String(describing: SidePanelTableViewCell.self)
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconLeadingAnchor: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        defaultConfiguration()
        
        setLabelShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func defaultConfiguration() {
        
        let clearBackgroundview = UIView()
        
        clearBackgroundview.backgroundColor = .sidePanelBlue
        
        self.backgroundView = clearBackgroundview
    }
    
    private func setLabelShadow() {
        
        titleLabel.backgroundColor = .clear
        
        titleLabel.textColor = .white
        
        titleLabel.setShadow(color: .black, offset: CGSize(width: 1, height: 1), opacity: 1.0, radius: 3)
        
    }
    
    func renderUI(title: String, imageName: String) {
        
        titleLabel.text = title
        
        itemImageView.image = UIImage(named: imageName)
        
        iconLeadingAnchor.constant = UIScreen.main.bounds.width * 0.141
    }
}
