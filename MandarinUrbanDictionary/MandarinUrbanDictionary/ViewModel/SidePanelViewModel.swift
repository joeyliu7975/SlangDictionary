//
//  SidePanelViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import Foundation

class SidePanelViewModel {
    typealias Item = SidePanel.Icon
    
    let sidePanelItems = SidePanel.allCases
    
    func selectItem(index: Int) -> SidePanel {
        return sidePanelItems[index]
    }
    
    func getItem(index: Int) -> Item {
        return sidePanelItems[index].makeIcon()
    }
}
