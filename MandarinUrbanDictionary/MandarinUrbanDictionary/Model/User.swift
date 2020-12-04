//
//  User.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/4/20.
//

import Foundation

struct User: Codable {
    
    let identifier: String
    
    var name: String
    
    var favorites: [String]
    
    var recents: [String]
    
    enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        
        case name = "display_name"
        
        case recents = "recent_search"
        
        case favorites = "favorite_words"
    }
}
