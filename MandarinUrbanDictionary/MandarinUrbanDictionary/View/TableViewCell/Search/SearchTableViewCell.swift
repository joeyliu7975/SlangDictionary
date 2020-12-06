//
//  SearchTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/6/20.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifierName = String(describing: SearchTableViewCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectedBackgroundView = UIView()
    }
    
    func renderUI(_ data: String) {
        
        
        
    }
    
    func makeLabel(_ strings: [String]) {
        
    }
}
