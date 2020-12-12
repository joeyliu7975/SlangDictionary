//
//  TopFiveCollectionViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/12/20.
//

import UIKit

class TopFiveCollectionViewCell: UICollectionViewCell {

    static let reusableIdentifier = String(describing: TopFiveCollectionViewCell.self)
    
    @IBOutlet weak var rankBoardView: UIView!
    
    lazy var crownView: UIImageView = {
       
        let crownView = UIImageView()
        
        crownView.translatesAutoresizingMaskIntoConstraints = false
        
        return crownView
    }()
    
    override func prepareForReuse() {
        crownView.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        rankBoardView.setCorner(radius: rankBoardView.bounds.height / 2)
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func makeCrown() {
        
        rankBoardView.addSubview(crownView)
        
        crownView.contentMode = .scaleToFill
        
        crownView.image = UIImage(named: ImageConstant.crown)
        
        NSLayoutConstraint.activate([
            crownView.heightAnchor.constraint(equalToConstant: 35),
            crownView.widthAnchor.constraint(equalToConstant: 35),
            crownView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            crownView.leadingAnchor.constraint(equalTo: rankBoardView.leadingAnchor, constant: 15)
        ])
    }

}
