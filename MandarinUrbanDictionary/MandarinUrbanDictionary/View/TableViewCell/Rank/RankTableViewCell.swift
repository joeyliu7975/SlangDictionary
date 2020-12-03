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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        let crownView = UIImageView(frame: CGRect(x: 14, y: titleLabel.frame.minY, width: 35, height: 35))
        
        crownView.contentMode = .scaleToFill
        
        crownView.image = UIImage(named: JoeyImage.crown)
        
        rankBoardView.addSubview(crownView)
        
    }
}
