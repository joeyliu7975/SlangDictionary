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
    
    var view: Int
    
    let id: String
    
    let time: Date?
    
    enum CodingKeys: String, CodingKey {
        
        case name, definition, view, id
        
        case time = "created_time"
    }
    
}
