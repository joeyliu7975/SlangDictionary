//
//  HomepageTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import UIKit

class HomepageTableViewCell: UITableViewCell {

    static let reusableIdentifier = String(describing: HomepageTableViewCell.self)
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectedBackgroundView = UIView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(word: String, definition: String) {
        wordLabel.text = word
        definitionLabel.text = definition
    }
    
}
