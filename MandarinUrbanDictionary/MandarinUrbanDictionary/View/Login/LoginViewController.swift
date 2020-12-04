//
//  LoginViewController.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/3/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appleLoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
        setupGestures()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        addSubLayers()
        
    }
    
    @objc func tap() {
        print("Login with Apple")
    }
}

private extension LoginViewController {
    
    func setup() {
        
        appleLoginView.setCorner(radius: 10.0)

    }
    
    func setupGestures() {
        
        appleLoginView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        appleLoginView.addGestureRecognizer(tapGesture)
        
    }
    
    func addSubLayers() {
        
        let appleImageLayer = CALayer()
        
        let appleTextLayer = JoeyTextLayer()
        
        let appleIconImage = UIImage(named: ImageConstant.appleIcon)?.cgImage
        
        appleImageLayer.frame = CGRect(x: 40, y: 12, width: 36, height: 36)
        
        appleTextLayer.frame = CGRect(x: 86, y: 12, width: 200, height: 36)
        
        appleTextLayer.fontSize = 24.0
                
        appleTextLayer.string = "Sign in with Apple"
        
        appleImageLayer.contents = appleIconImage
        
        appleLoginView.layer.addSublayer(appleImageLayer)
        
        appleLoginView.layer.addSublayer(appleTextLayer)
        
    }
    
}
