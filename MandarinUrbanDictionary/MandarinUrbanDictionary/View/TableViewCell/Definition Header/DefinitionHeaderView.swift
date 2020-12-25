//
//  DefinitionHeaderView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

protocol DefinitionHeaderDelegate: class {
    
    func toggleFavorite(_ isFavorite: Bool)
    
    func writeNewDefinition()
    
    func clickBackButton()
    
    func clickReadOut(_ sender: UIButton)
}

final class DefinitionHeaderView: UITableViewHeaderFooterView {
    
    static let identifierName = String(describing: DefinitionHeaderView.self)
    
    @IBOutlet var wordLabel: UILabel!
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var writeDefinition: UIButton!
    
    @IBOutlet weak var categoryContainerView: UIView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var customBackButton: UIButton!
    
    @IBOutlet weak var siriReadButton: UIButton!
    
    weak var delegate: DefinitionHeaderDelegate?
    
    var isFavorite: Bool = false {
        didSet {
            setFavoriteButton()
        }
    }
        
    @IBAction func clickButton(_ sender: UIButton) {
        
        switch sender {
        
        case favoriteButton:
            
            isFavorite.toggle()
            
            delegate?.toggleFavorite(isFavorite)
            
        case writeDefinition:
            
            delegate?.writeNewDefinition()
        
        case customBackButton:
            
            delegate?.clickBackButton()
            
        case siriReadButton:
            
            delegate?.clickReadOut(sender)
        default:
            
            break
            
        }
    }
    
    func renderUI(category: String, word: String) {
        
        let categoryImage = Category(rawValue: category)!.instance()
        
        wordLabel.text = word
        
        categoryLabel.text = category
        
        categoryLabel.textColor = .separatorlineBlue
        
        categoryContainerView.backgroundColor = .white
        
        categoryContainerView.setCorner(radius: 5)
        
        categoryImageView.image = UIImage(named: categoryImage.image)
        
        siriReadButton.setImage(UIImage(named: ImageConstant.speakerHighlightened), for: .highlighted)
        
        siriReadButton.setImage(UIImage(named: ImageConstant.speakerHighlightened), for: .disabled)
    }
    
    func setFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
    
    private func setFavoriteButton() {
        
        switch isFavorite {
        
        case true:
            
            favoriteButton.setImage(
                UIImage(named: ImageConstant.isFavorite),
                for: .normal
            )
            
        case false:
            
            favoriteButton.setImage(
                UIImage(named: ImageConstant.unfavorite),
                for: .normal
            )
            
        }
    }
}
