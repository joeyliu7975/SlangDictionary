//
//  DefinitionTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

class DefinitionTableViewCell: UITableViewCell {
    
    static let identifierName = String(describing: DefinitionTableViewCell.self)

    @IBOutlet weak var rankLabelView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var amountOfLikesLabel: UILabel!
    @IBOutlet weak var amountOfDislikesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        defaultConfiguration()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectedBackgroundView = UIView()
    }
    
    private func defaultConfiguration() {
        rankLabelView.setCorner(radius: 10.0)
        rankLabelView.backgroundColor = .rankLabelBackgroundBlue
    }
    
    func renderUI(rank: String, isLiked:Bool, amountOfLike: Int, amountOfDislike: Int, isReported: Bool, content: String) {
        rankLabel.text = rank
        amountOfLikesLabel.text = String(describing: amountOfLike)
        amountOfDislikesLabel.text = String(describing: amountOfDislike)
        definitionTextView.text = content
    }
}
