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
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        logoImageView.image = nil
        
        titleLabel.text = ""
        
        categoryLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
    }
    
    func setup() {
        self.backgroundColor = .homepageDarkBlue
        
        self.categoryView.backgroundColor = .homepageDarkBlue
        
        self.categoryLabel.tintColor = .homepageLightBlue
        
        self.categoryView.setCorner(radius: 5)
        
        self.selectedBackgroundView = UIView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(title: String, category: String, image: String) {
        
        let categoryImage = Category(rawValue: category)!.instance()
        
        titleLabel.text = title
        
        categoryLabel.text = category
        
        logoImageView.image = UIImage(named: image)
        
        categoryImageView.image = UIImage(named: categoryImage.image)
    }
    
}
