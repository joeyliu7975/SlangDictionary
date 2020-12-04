//
//  Report.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/2/20.
//

import Foundation
import Firebase

struct Report: Codable {
    
    let userIdentifierNumber: String
    
    let time: Timestamp
    
    let reason: String
        
    enum CodingKeys: String, CodingKey {
        
        case userIdentifierNumber, time, reason
        
    }
}
