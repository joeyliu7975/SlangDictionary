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
    
    init(content: String, like: [String] = [], dislike: [String] = [], id: String, time: FirebaseTime = .init(), wid: String) {
        self.content = content
        self.like = like
        self.dislike = dislike
        self.identifier = id
        self.time = time
        self.idForWord = wid
    }
    
    /*
    let definition = Definition(
        content: userDefinition,
        like: [String](),
        dislike: [String](),
        identifier: defID,
        time: FirebaseTime(),
        idForWord: wordID
    )
 */
    
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
