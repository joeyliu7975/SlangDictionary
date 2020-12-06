//
//  Report.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import Foundation

struct Report: Codable {
    
    let userIdentifierNumber: String
    
    let time: FirebaseTime
    
    let reason: String
        
    enum CodingKeys: String, CodingKey {
        
        case userIdentifierNumber, time, reason
        
    }
}
