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
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectedBackgroundView = UIView()
    }
    
    func renderUI(_ text: String, keyword: String?, category: String) {
        
        let categoryImage = Category(rawValue: category)!.instance()
        
        wordLabel.text = text
        
        logoImageView.image = UIImage(named: categoryImage.image)
        
        if let keyword = keyword {
            
            wordLabel.replaceKeywordColor(with: .systemBlue, keyword: keyword)
            
        }
    }
}
