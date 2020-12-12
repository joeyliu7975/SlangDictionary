//
//  Category.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/1/20.
//

import UIKit

enum Category: String, CaseIterable {
    
    case all = "All"
    
    case engineer = "Engineer"
    
    case job = "Workplace"
    
    case school = "School"
    
    case pickUpLine = "Pickup Line"
    
    case restaurant = "Restaurant"
    
    case game = "Game"
    
    case gym = "Gym"
    
    case relationship = "Relationship"
    
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
