//
//  FavoriteTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    static let identifierName = String(describing: FavoriteTableViewCell.self)

    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var wordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(word: String) {
        wordLabel.text = word
    }
    
    private func setup() {
        cardView.backgroundColor = .cardViewBlue
    }
}
