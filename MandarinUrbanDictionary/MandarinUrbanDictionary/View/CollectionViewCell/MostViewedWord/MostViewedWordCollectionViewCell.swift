//
//  MostViewedWordCollectionViewCell.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit

class MostViewedWordCollectionViewCell: UICollectionViewCell {
    
    static let identifierName = String(describing: MostViewedWordCollectionViewCell.self)

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topViewWordLabel: UILabel!
    @IBOutlet weak var bottomViewDefinitionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
