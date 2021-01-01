//
//  HUDAnimation.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/26/20.
//

import PKHUD
import Lottie

class HUDAnimation {
    
    static func makeLottieAnimation(_ animation: LottieAnimation) -> UIView {
        var animationView = AnimationView()
        
        switch animation {
        case .success:

            animationView = .init(name: "success_Animation")

        case .failure:

            animationView = .init(name: "lottie_Failure")
            
        }
        
        animationView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        animationView.contentMode = .scaleAspectFit
        
        animationView.loopMode = .playOnce
        
        animationView.animationSpeed = 2.0
        
        animationView.play()
        
        return animationView
    }
    
    static func showSuccess(at viewController: HUDAnimation.ViewController,completion:@escaping () -> Void) {
        
        switch viewController {
        case .newWord:
            HUD.flash(.labeledSuccess(title: "新增成功", subtitle: String.emptyString), delay: 0.0)
        case .report:
            HUD.flash(.labeledSuccess(title: "檢舉成功", subtitle: String.emptyString), delay: 0.0)
        }
        
        HUD.hide(afterDelay: 1.5) { (success) in
            completion()
        }
    }
    
    static func showError(at viewController: HUDAnimation.ViewController, completion:@escaping () -> Void) {
        
        switch viewController {
        case .newWord:
            HUD.flash(.labeledError(title: "該詞已經存在", subtitle: String.emptyString), delay: 0.0)
        case .report:
            HUD.flash(.labeledError(title: "檢舉失敗", subtitle: String.emptyString), delay: 0.0)
        }
        
        HUD.hide(afterDelay: 1.5) { (success) in
            
            completion()
            
        }
    }
}

extension HUDAnimation {
    enum LottieAnimation {
        case success
        case failure
    }
    
    enum ViewController {
        case newWord
        case report
    }
}
