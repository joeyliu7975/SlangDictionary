//
//  DailyWord.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/17/20.
//

import Foundation

struct DailyWord: Codable {
    let id: String
    let time: FirebaseTime
    
    enum CodingKeys: String, CodingKey {
        case id = "word_id"
        case time = "today"
    }
}
