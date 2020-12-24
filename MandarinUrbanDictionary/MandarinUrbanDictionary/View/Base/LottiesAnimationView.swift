//
//  LottiesAnimationView.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/23/20.
//

import UIKit
import Lottie

class LottiesAnimationView: UIView {

    static let shared: LottiesAnimationView = .init()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String = "loading_Lotties") {
        var animationView = AnimationView()
         
         animationView = .init(name: name)
         
         animationView.frame = self.bounds
         
         animationView.contentMode = .scaleAspectFit
         
         animationView.loopMode = .loop
        
        addSubview(animationView)
    }
    
    func start() {
        
    }

    
}
