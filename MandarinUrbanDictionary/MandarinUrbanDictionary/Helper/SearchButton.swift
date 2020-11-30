//
//  SearchButton.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/28/20.
//

import UIKit

class SearchButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
        
        self.backgroundColor = .homepageLightBlue
        self.imageView?.contentMode = .scaleAspectFit
        self.setTitleColor(.homepageDarkBlue, for: .normal)
    }
}
