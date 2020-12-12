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

    @IBOutlet weak var wordLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectedBackgroundView = UIView()
    }
    
    func renderUI(_ text: String, keyword: String?) {
        
        wordLabel.text = text
        
        if let keyword = keyword {
            
            wordLabel.replaceKeywordColor(with: .systemBlue, keyword: keyword)
            
        }
    }
}
