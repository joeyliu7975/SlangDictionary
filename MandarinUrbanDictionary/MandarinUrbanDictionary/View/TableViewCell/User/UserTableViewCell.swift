//
//  UserTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/18/20.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: UserTableViewCell.self)
    
    @IBOutlet weak var challengLabel: UILabel!
    @IBOutlet weak var progressionBarContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(title: String) {
        
        challengLabel.text = title
        
    }
    
}
