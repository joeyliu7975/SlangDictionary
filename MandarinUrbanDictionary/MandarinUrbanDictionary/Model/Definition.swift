//
//  Definition.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import Foundation
import Firebase

struct Definition: Codable {
    
    let content: String
    
    var like: [String]
    
    var dislike: [String]
    
    var report: String
    
    var identifier: String
    
    var time: Timestamp
    
    var idForWord: String
    
    enum CodingKeys: String, CodingKey {
        
        case content, like, dislike, report, identifier
        
        case time = "created_time"
        
        case idForWord = "word_id"
    }
}
