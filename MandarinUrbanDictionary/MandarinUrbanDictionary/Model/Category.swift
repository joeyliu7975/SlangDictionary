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
            return Instance(name: self.rawValue, image: "puzzle")
        case .engineer:
            return Instance(name: self.rawValue, image: "puzzle")
        case .job:
            return Instance(name: self.rawValue, image: "puzzle")
        case .school:
            return Instance(name: self.rawValue, image: "puzzle")
        case .pickUpLine:
            return Instance(name: self.rawValue, image: "puzzle")
        case .restaurant:
            return Instance(name: self.rawValue, image: "puzzle")
        case .game:
            return Instance(name: self.rawValue, image: "puzzle")
        case .gym:
            return Instance(name: self.rawValue, image: "puzzle")
        case .relationship:
            return Instance(name: self.rawValue, image: "puzzle")
        }
    }
}
