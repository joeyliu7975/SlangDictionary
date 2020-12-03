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
    
    typealias Icon = Item
    
    struct Item {
        let name: String
        let image: String
    }
    
     func makeIcon() -> Icon {
        switch self {
        case .all:
            return Icon(name: self.rawValue, image: "puzzle")
        case .engineer:
            return Icon(name: self.rawValue, image: "puzzle")
        case .job:
            return Icon(name: self.rawValue, image: "puzzle")
        case .school:
            return Icon(name: self.rawValue, image: "puzzle")
        case .pickUpLine:
            return Icon(name: self.rawValue, image: "puzzle")
        case .restaurant:
            return Icon(name: self.rawValue, image: "puzzle")
        case .game:
            return Icon(name: self.rawValue, image: "puzzle")
        case .gym:
            return Icon(name: self.rawValue, image: "puzzle")
        case .relationship:
            return Icon(name: self.rawValue, image: "puzzle")
        }
    }
}
