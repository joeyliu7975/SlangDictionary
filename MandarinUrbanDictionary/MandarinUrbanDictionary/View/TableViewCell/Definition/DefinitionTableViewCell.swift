//
//  DefinitionTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

class DefinitionTableViewCell: UITableViewCell {

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(isLiked:Bool, amountOfLike: Int, amountOfDislike: Int, isReported: Bool) {
        
    }
}
