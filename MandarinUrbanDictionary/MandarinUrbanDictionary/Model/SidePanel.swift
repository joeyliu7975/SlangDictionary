//
//  SidePanel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import Foundation

protocol IconFactory {
    
    associatedtype Instance
    
    func instance() -> Instance
    
}

enum SidePanel: String, CaseIterable {
    
    case homePage = "Dictionary"
    
    case dailySlang = "Daily Slang"
    
    case top5 = "Top 5"
    
    case favorite = "Favorite"
    
    case recents = "Recents"
    
    case quiz = "Quiz"
    
    case user = "User"
    
}

extension SidePanel: IconFactory {
    
    typealias Instance = Item
    
    struct Item {
        
        let name: String
        
        let image: String
        
    }
    
    func instance() -> Instance {
        
        switch self {
        
        case .homePage:
            
            return Instance(
                name: rawValue,
                image: ImageConstant.dictionary
            )
            
        case .dailySlang:
            
            return Instance(
                name: rawValue,
                image: ImageConstant.calendar
            )
            
        case .top5:
            
            return Instance(
                name: rawValue,
                image: ImageConstant.rank
            )
            
        case .favorite:
            
            return Instance(
                name: rawValue,
                image: ImageConstant.favoriteSideMenu
            )
            
        case .recents:
            
            return Instance(
                name: rawValue,
                image: ImageConstant.clock
            )
            
        case .quiz:
            
            return Instance(
                name: rawValue,
                image: ImageConstant.puzzle
            )
            
        case .user:
            
            return Instance(
                name: rawValue,
                image: ImageConstant.nest
            )
            
        }
    }
}
