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
    
    var report: String
    
    var id: String
    
    var time: TimeInterval
    
    var idForWord: String
    
    enum CodingKeys: String, CodingKey {
        case content, like, dislike, report, id
        case time = "created_time"
        case idForWord = "word_id"
    }
}

struct Report: Codable {
    var content: String
    
    var reportTargetID: String
    
}
