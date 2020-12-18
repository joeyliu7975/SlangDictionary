//
//  Category.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

enum Category: String, CaseIterable {
    
    case all = "全部"
    
    case engineer = "工程師"
    
    case job = "工作"
    
    case school = "校園"
    
    case pickUpLine = "撩妹"
    
    case restaurant = "餐廳"
    
    case game = "遊戲"
    
    case gym = "健身"
    
    case relationship = "感情"
    
}

extension Category: IconFactory {
    
    typealias Instance = Item
    
    struct Item {
        
        let name: String
        
        let image: String
    }
    
     func instance() -> Instance {
        switch self {
        case .all:
            return Instance(name: self.rawValue, image: "all_64x64")
        case .engineer:
            return Instance(name: self.rawValue, image: "engineer_64x64")
        case .job:
            return Instance(name: self.rawValue, image: "workplace_64x64")
        case .school:
            return Instance(name: self.rawValue, image: "student_64x64")
        case .pickUpLine:
            return Instance(name: self.rawValue, image: "flirting_64x64")
        case .restaurant:
            return Instance(name: self.rawValue, image: "restaurant_64x64")
        case .game:
            return Instance(name: self.rawValue, image: "game_64x64")
        case .gym:
            return Instance(name: self.rawValue, image: "gym_64x64")
        case .relationship:
            return Instance(name: self.rawValue, image: "couple_64x64")
        }
    }
}
