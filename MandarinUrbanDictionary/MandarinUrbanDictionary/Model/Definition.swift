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
        
    var identifier: String
    
    var time: FirebaseTime
    
    var idForWord: String
    
    enum CodingKeys: String, CodingKey {
        
        case content, like, dislike
        
        case identifier = "id"
        
        case time = "created_time"
        
        case idForWord = "word_id"
    }
}

extension Definition: FirebaseItem {
        typealias Item = [String: Any]
        
        var dictionary: Item {
            return [
                "content": content,
                "like": like,
                "dislike": dislike,
                "id": identifier,
                "created_time": time,
                "word_id": idForWord
            ]
        }
}

extension Definition {
    
    enum Opinion {
        
        case like, dislike, none
        
    }
    
    func showUserOpinion(_ id: String) -> Opinion {
        
        if like.contains(id) {
            return .like
        } else if dislike.contains(id) {
            return .dislike
        } else {
            return .none
        }
        
    }
    
}
