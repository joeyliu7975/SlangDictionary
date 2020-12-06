//
//  Word.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import Foundation

struct Word: Codable {
    
    let name: String
    
    var definition: [String]
    
    let category: String
    
    var view: Int
    
    var identifier: String
    
    let time: FirebaseTime
    
    enum CodingKeys: String, CodingKey {
        
        case name, definition, view, identifier, category
        
        case time = "created_time"
    }
    
}

extension Word {
    
    mutating func updateId(_ id: String) {
        
        self.identifier = id
        
    }
    
}
