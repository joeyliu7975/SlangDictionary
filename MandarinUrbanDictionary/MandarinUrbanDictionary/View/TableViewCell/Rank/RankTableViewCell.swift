//
//  RankTableViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit

class RankTableViewCell: UITableViewCell {
    
    static let identifierName = String(describing: RankTableViewCell.self)

    @IBOutlet weak var rankBoardView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var crownView: UIImageView = {
       
        let crownView = UIImageView()
        
        crownView.translatesAutoresizingMaskIntoConstraints = false
        
        return crownView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        crownView.removeFromSuperview()
    }
    
    override func layoutSubviews() {
        rankBoardView.setCorner(radius: rankBoardView.bounds.height / 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func renderUI(boardColor color: UIColor, title: String) {
        
        rankBoardView.backgroundColor = color
        
        titleLabel.text = title
    }
    
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
