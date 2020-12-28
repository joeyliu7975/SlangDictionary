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
    
    case homePage = "辭海"
    
    case dailySlang = "每日一句"
    
    case top5 = "排行榜"
    
    case favorite = "我的最愛"
    
    case recents = "歷史紀錄"
        
    case achievement = "成就"
    
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
            
        case .achievement:
            
            return Instance(
                name: rawValue,
                image: ImageConstant.goal
            )
            
        }
    }
}
