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
    
    var discoveredWords: [String]
    
    enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        
        case name = "display_Name"
        
        case recents = "recent_search"
        
        case favorites = "favorite_words"
        
        case discoveredWords = "discovered_words"
    }
}

extension User: FirebaseItem {
    typealias Item = [String: Any]
    
    var dictionary: Item {
        return [
            "id": identifier,
            "display_Name": name,
            "recent_search": recents,
            "favorite_words": favorites,
            "discovered_words": discoveredWords
        ]
    }
}
