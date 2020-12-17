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
    
    func makeCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("CollectionView Cell Does Not Exist!")
        }
        
        return cell
    }
}
