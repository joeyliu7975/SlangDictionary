//
//  TheNewestWordTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/12/20.
//

import UIKit

class TheNewestWordTableViewCell: UITableViewCell {

    static let reusableIdentifier = String(describing: TheNewestWordTableViewCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
    }
    
    func setup() {
        self.backgroundColor = .homepageDarkBlue
        
        self.selectedBackgroundView = UIView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(title: String, description: String) {
        
        titleLabel.text = title
        
        descriptionLabel.text = description
    }
    
}
