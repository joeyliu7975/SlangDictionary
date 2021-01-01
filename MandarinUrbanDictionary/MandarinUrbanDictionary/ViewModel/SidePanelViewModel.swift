//
//  SidePanelViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import Foundation

class SidePanelViewModel {
    
    typealias Item = SidePanel.Instance
    
    let sideMenuItems = SidePanel.allCases
    
    func item(selectIndexAt index: Int) -> SidePanel {
        return sideMenuItems[index]
    }
    
    func item(getIndexAt index: Int) -> Item {
        return sideMenuItems[index].instance()
    }
}
