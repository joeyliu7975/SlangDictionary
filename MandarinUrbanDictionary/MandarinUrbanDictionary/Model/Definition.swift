//
//  Definition.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import Foundation

struct Definition: Codable {
    
    let content: String
    
    var like: [String]
    
    var dislike: [String]
        
    var identifier: String
    
    var time: FirebaseTime
    
    var idForWord: String
    
    enum CodingKeys: String, CodingKey {
        
        case content, like, dislike
        
        case identifier = "id"
        
        case time = "created_time"
        
        case idForWord = "word_id"
    }
}
