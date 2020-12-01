//
//  newPostButtonView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import UIKit

protocol PostButtonDelegate: class {
    func clickButton(_ sender: UIButton)
}

class NewPostButtonView: UIView {

    @IBOutlet weak var writeButton: UIButton!
    
    weak var delegate: PostButtonDelegate?
    
    @IBAction func writeNewPost(_ sender: UIButton) {
        delegate?.clickButton(sender)
    }    
}
