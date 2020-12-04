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
            
            return Icon(
                name: rawValue,
                image: ImageConstant.dictionary
            )
            
        case .dailySlang:
            
            return Icon(
                name: rawValue,
                image: ImageConstant.calendar
            )
            
        case .top5:
            
            return Icon(
                name: rawValue,
                image: ImageConstant.rank
            )
            
        case .favorite:
            
            return Icon(
                name: rawValue,
                image: ImageConstant.favoriteSideMenu
            )
            
        case .recents:
            
            return Icon(
                name: rawValue,
                image: ImageConstant.clock
            )
            
        case .quiz:
            
            return Icon(
                name: rawValue,
                image: ImageConstant.puzzle
            )
            
        case .login:
            
            return Icon(
                name: rawValue,
                image: ImageConstant.nest
            )
            
        }
    }
}
