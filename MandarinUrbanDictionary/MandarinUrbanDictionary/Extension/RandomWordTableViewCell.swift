//
//  RandomWordTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/17/20.
//

import UIKit

protocol RandomWordTableViewDelegate: class {
    
    func getRandomWord(_ cell: UITableViewCell)
    
}

class RandomWordTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: RandomWordTableViewCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    weak var delegate: RandomWordTableViewDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryImageView.image = nil
        
        categoryLabel.text = ""
        
        titleLabel.text = ""
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setup()
        
        imageAction()
    }
    
    private func setup() {
        self.backgroundColor = .homepageDarkBlue
        
        self.categoryView.backgroundColor = .homepageDarkBlue
        
        self.categoryLabel.tintColor = .homepageLightBlue
        
        self.categoryView.setCorner(radius: 5)
        
        self.selectedBackgroundView = UIView()
    }
    
    private func imageAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        self.logoImageView.isUserInteractionEnabled = true
        
        self.logoImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        delegate?.getRandomWord(self)
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
