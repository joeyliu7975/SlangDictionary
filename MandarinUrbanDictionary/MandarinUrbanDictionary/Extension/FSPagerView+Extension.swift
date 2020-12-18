//
//  FSPagerView+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import FSPagerView

extension FSPagerView {
    
    func registerCell(_ cellName: String) {
        let nib = UINib(nibName: cellName, bundle: nil)
        
        self.register(nib, forCellWithReuseIdentifier: cellName)
    }
}
