//
//  DailyTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/23/20.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: DailyTableViewCell.self)

    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        
        self.selectedBackgroundView = UIView()
        
        setup()
    }
    
    private func setup() {
        
        cardView.backgroundColor = .cardViewBlue
        
        dateLabel.textColor = .cardViewBlue
        
        wordLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
