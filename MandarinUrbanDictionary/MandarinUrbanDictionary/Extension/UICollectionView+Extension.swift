//
//  UICollectionView+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit

extension UICollectionView {
    
    func registerCell(_ cellName: String) {
        let nib = UINib(nibName: cellName, bundle: nil)
        
        self.register(nib, forCellWithReuseIdentifier: cellName)
    }
}
