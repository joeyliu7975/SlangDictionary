//
//  UIButton+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import UIKit

extension UIButton {
  
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
    
    static func makeButton(buttonType button: UIButton.CustomButtonType) -> UIButton {
        let customButton = UIButton()
        
        switch button {
        
        case .rightBarButtonItem(let imageName):
            
            customButton.imageView?.contentMode = .scaleToFill
            
            customButton.translatesAutoresizingMaskIntoConstraints = false
            
            customButton.setImage(UIImage(named: imageName), for: .normal)
            
            customButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
            
            customButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
        case .spacerButton:
            
            customButton.translatesAutoresizingMaskIntoConstraints = false
            
            customButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            
            customButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            customButton.isUserInteractionEnabled = false
        }
        
        return customButton
    }
}

extension UIButton {
    enum CustomButtonType {
        case rightBarButtonItem(image: String)
        case spacerButton
    }
}
