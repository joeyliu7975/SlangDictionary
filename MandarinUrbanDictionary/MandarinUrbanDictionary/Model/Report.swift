//
//  Report.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import Foundation

struct Report: Codable {
    
    let uid: String
    
    let id: String
    
    let time: FirebaseTime = FirebaseTime()
    
    let reason: String
        
    enum CodingKeys: String, CodingKey {
        
        case uid, time, reason, id
        
    }
}

extension Report: FirebaseItem {
    
    typealias Item = [String: Any]
    
    var dictionary: Item {
        return [
            "uid": uid,
            "time": time,
            "reason": reason,
            "id": id
        ]
    }
    
}
