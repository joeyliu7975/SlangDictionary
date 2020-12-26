//
//  HUDAnimation.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/26/20.
//

import PKHUD

class HUDAnimation {
    static func showSuccess(completion:@escaping () -> Void) {
        HUD.flash(.labeledSuccess(title: "新增成功", subtitle: ""), delay: 0.25)
        
        HUD.hide(afterDelay: 0.75) { (success) in
            completion()
        }
    }
    
    static func showError(completion:@escaping () -> Void) {
        HUD.flash(.labeledError(title: "該字已經存在", subtitle: ""), delay: 0.0)
        
        HUD.hide(afterDelay: 0.75) { (success) in
            
            completion()
            
        }
    }
}
