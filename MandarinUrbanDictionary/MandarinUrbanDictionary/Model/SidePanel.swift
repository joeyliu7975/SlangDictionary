//
//  SidePanel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import Foundation

protocol IconFactory {
    associatedtype Icon
    
    func makeIcon() -> Icon
}

enum SidePanel: String, CaseIterable {
    case homePage = "Dictionary"
    case dailySlang = "Daily Slang"
    case top5 = "Top 5"
    case favorite = "Favorite"
    case recents = "Recents"
    case quiz = "Quiz"
    case login = "Login"
}

extension SidePanel: IconFactory {
    
    typealias Icon = Item
    
    struct Item {
        let name: String
        let image: String
    }
    
    func makeIcon() -> Icon {
        switch self {
        case .homePage:
            return Icon(name: "Dictionary", image: "dictionary")
        case .dailySlang:
            return Icon(name: "Daily Slang", image: "calendar")
        case .top5:
            return Icon(name: "Top 5", image: "winner")
        case .favorite:
            return Icon(name: "Favorite", image: "heart")
        case .recents:
            return Icon(name: "Recents", image: "clock")
        case .quiz:
            return Icon(name: "Quiz", image: "puzzle")
        case .login:
            return Icon(name: "Login", image: "nest")
        }
    }
}
