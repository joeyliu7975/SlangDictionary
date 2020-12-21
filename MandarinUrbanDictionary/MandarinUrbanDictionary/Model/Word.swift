//
//  Word.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/25/20.
//

import Foundation

struct Word: Codable, Equatable {
    
    let title: String
        
    let category: String
    
    var views: Int
    
    var identifier: String
    
    let time: FirebaseTime
    
    init (title: String, category: String, views: Int = 0, id: String, time: FirebaseTime = FirebaseTime()) {
        self.title = title
        self.category = category
        self.views = views
        self.identifier = id
        self.time = time
    }
    
    enum CodingKeys: String, CodingKey {
        
        case title, category
        
        case identifier = "id"
        
        case time = "created_time"
        
        case views = "check_times"
    }
}

extension Word: FirebaseItem {
    
    typealias Item = [String: Any]
    
    var dictionary: Item {
        return [
            "title": title,
            "category": category,
            "id": identifier,
            "created_time": time,
            "check_times": views
        ]
    }
    
}

extension Word {
    
    mutating func updateId(_ id: String) {
        
        self.identifier = id
        
    }
    
}

