//
//  DefinitionTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import UIKit

protocol DefinitionTableViewCellDelegate: class {
    func report(_ cell: DefinitionTableViewCell)
}

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
    
    @IBOutlet weak var separatorlineView: UIView!
    
    weak var delegate: DefinitionTableViewCellDelegate?
    
    override func prepareForReuse() {
        feedback(.none)
    }
    
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
    
    @IBAction func clickButton(_ sender: UIButton) {
        
        switch sender {
        
        case likeButton:
            
            feedback(.like)
            
        case dislikeButton:
            
            feedback(.dislike)
            
        case reportButton:
            
            delegate?.report(self)
            
        default:
            
            break
            
        }
    }
}

extension DefinitionTableViewCell {
    
    func renderUI(
        rank: String,
        isLiked: Definition.Opinion,
        amountOfLike: Int,
        amountOfDislike: Int,
        isReported: Bool,
        content: String
    ) {
        
        rankLabel.text = rank
        
        amountOfLikesLabel.text = String(describing: amountOfLike)
        
        amountOfDislikesLabel.text = String(describing: amountOfDislike)
        
        definitionTextView.text = content
        
        feedback(isLiked)
        
    }
}

private extension DefinitionTableViewCell {
    
   func defaultConfiguration() {
        rankLabelView.setCorner(radius: 10.0)
    
        rankLabelView.backgroundColor = .rankLabelBackgroundBlue
        
        let originLikeImage = UIImage(named: "like_button_image_25x25")
    
        let tintedLikeImage = originLikeImage?.withRenderingMode(.alwaysTemplate)
        
        let originDislikeImage = UIImage(named: "dislike_button_image_25x25")
    
        let tintedDislikeImage = originDislikeImage?.withRenderingMode(.alwaysTemplate)
        
        likeButton.setImage(tintedLikeImage, for: .normal)
    
        dislikeButton.setImage(tintedDislikeImage, for: .normal)
    
        separatorlineView.backgroundColor = .separatorlineBlue
        
        feedback(.none)
    }
    
    func feedback(_ feedback: Definition.Opinion) {
        
        switch feedback {
        
        case .like:
            
            likeButton.tintColor = .blue
            
            dislikeButton.tintColor = .black
            
        case .dislike:
            
            likeButton.tintColor = .black
            
            dislikeButton.tintColor = .blue
            
        case .none:
            
            likeButton.tintColor = .black
            
            dislikeButton.tintColor = .black
            
        }
    }
}
