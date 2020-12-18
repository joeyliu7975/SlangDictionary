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
    
    func addBorderView(_ borderView: inout UIView) {
        let bounds = imageView.bounds
        
        let frame = CGRect(
            x: bounds.minX - 4,
            y: bounds.minY - 4,
            width: bounds.width + 10,
            height: bounds.height + 10
        )
        
        borderView = UIView(frame: frame)
        
        borderView.center = imageView.center
        
        borderView.layer.borderWidth = 2.0
        
        borderView.layer.borderColor = UIColor.homepageDarkBlue.cgColor
        
        insertSubview(borderView, aboveSubview: imageView)
        
        categoryCellDidSelected()
    }
    
    func removeBorderView(_ borderView: inout UIView) {
        
        borderView.removeFromSuperview()
        
        categoryCellDidDeselected()
    }
}

private extension CategoryCollectionViewCell {
    
    func categoryCellDidSelected() {
        titleLabel.textColor = .homepageDarkBlue
    }
    
    func categoryCellDidDeselected() {
        titleLabel.textColor = .black
    }
}
