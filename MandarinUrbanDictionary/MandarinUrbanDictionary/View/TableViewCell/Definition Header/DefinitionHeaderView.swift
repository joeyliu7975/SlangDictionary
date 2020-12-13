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
    
}

final class DefinitionHeaderView: UITableViewHeaderFooterView {
    
    static let identifierName = String(describing: DefinitionHeaderView.self)
    
    @IBOutlet var wordLabel: UILabel!
    
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var writeDefinition: UIButton!
    
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
            
        default:
            
            break
            
        }
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
