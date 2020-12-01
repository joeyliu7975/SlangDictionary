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

extension Category {
    
    struct CategoryItem {
        let name: String
        let image: String
    }
    
    var title: String {
        return self.makeIcon().name
    }
    
    var image: String {
        return self.makeIcon().image
    }
    
    private func makeIcon() -> CategoryItem {
        switch self {
        case .all:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        case .engineer:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        case .job:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        case .school:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        case .pickUpLine:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        case .restaurant:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        case .game:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        case .gym:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        case .relationship:
            return CategoryItem(name: self.rawValue, image: "puzzle")
        }
    }
}
