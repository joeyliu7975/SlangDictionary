//
//  SidePanelViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import Foundation

enum SidePanel: String, CaseIterable {
    case dictionary = "Dictionary"
    case dailySlang = "Daily Slang"
    case top5 = "Top 5"
    case favorite = "Favorite"
    case recents = "Recents"
    case quiz = "Quiz"
    case login = "Login"
    
    var imageName: String {
        switch self {
        case .dictionary:
            return "dictionary"
        case .dailySlang:
            return "calendar"
        case .top5:
            return "winner"
        case .favorite:
            return "heart"
        case .recents:
            return "clock"
        case .quiz:
            return "puzzle"
        case .login:
            return "nest"
        }
    }
}

class SidePanelViewModel {
    let sidePanelItems = SidePanel.allCases
    
    func getItem(index: Int) -> PanelItem {
        let panelName = sidePanelItems[index]
        
        let item = self.getPanelPackage(panelName)
        
        return item
    }
    
    private func getPanelPackage(_ panel: SidePanel) -> PanelItem {
        return PanelItem(imageName: panel.imageName, title: panel.rawValue)
    }
}

struct PanelItem {
    let imageName: String
    let title: String
}
