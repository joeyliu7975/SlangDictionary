//
//  MostViewedWordCollectionViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit
import FSPagerView

class MostViewedWordCollectionViewCell:  FSPagerViewCell{
    
    static let identifierName = String(describing: MostViewedWordCollectionViewCell.self)

    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var topViewWordLabel: UILabel!
    
    @IBOutlet weak var bottomViewDefinitionLabel: UILabel!
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultConfiguration()
    }
    
    func defaultConfiguration() {
        topView.backgroundColor = .homepageDarkBlue
    }
    
    func renderImage(name: String) {
        contentImageView.image = UIImage(named: name)
    }
}
