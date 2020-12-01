//
//  CategoryCollectionViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifierName = String(describing: CategoryCollectionViewCell.self)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func renderUI(title: String, image: String) {
        titleLabel.text = title
        imageView.image = UIImage(named: image)
    }
}
