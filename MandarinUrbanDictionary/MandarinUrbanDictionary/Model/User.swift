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
    
    var favoriteChallenge: Int
    
    var postChallenge: Int
    
    var viewChallenge: Int
    
    enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        
        case name = "display_Name"
        
        case recents = "recent_search"
        
        case favorites = "favorite_words"
        
        case discoveredWords = "discovered_words"
        
        case favoriteChallenge = "favorite_challenge"
        
        case postChallenge = "post_challenge"
        
        case viewChallenge = "view_challenge"
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
            "discovered_words": discoveredWords,
            "favorite_challenge": favoriteChallenge,
            "post_challenge": postChallenge,
            "view_challenge": viewChallenge
        ]
    }
}
