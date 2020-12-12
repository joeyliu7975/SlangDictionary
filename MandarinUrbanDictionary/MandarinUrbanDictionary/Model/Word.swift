//
//  Word.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import Foundation

struct Word: Codable {
    
    let title: String
        
    let category: String
    
    var views: Int
    
    var identifier: String
    
    let time: FirebaseTime
    
    enum CodingKeys: String, CodingKey {
        
        case title, category
        
        case identifier = "id"
        
        case time = "created_time"
        
        case views = "check_times"
    }
    
}

extension Word {
    
    mutating func updateId(_ id: String) {
        
        self.identifier = id
        
    }
    
}
