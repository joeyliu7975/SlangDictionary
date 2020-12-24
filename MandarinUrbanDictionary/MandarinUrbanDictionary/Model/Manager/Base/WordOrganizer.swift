//
//  WordOrganizer.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/24/20.
//

import Foundation

class WordOrganizer<T> {
    typealias Value = T
    
    var orderList = [String]()
    
    var pendingList = [String]()
    
    var wordDictionary = [String: Value]()
    
    private func getWord(key: String) -> Value? {
        guard let word = wordDictionary[key] else { return nil }
        return word
    }
}

extension WordOrganizer:Organizer {
    var pendingsIsEmpty: Bool {
        return pendingList.isEmpty
    }
    
    func append(id: String) {
        orderList.append(id)
        
        pendingList.append(id)
    }
    
    func add(key: String, value: Value) {
        wordDictionary[key] = value
    }
    
    func removeLastPending() {
        pendingList.removeLast()
    }
    
    func organizeWords() -> [Value] {
        var words = [Value]()
        
        for id in orderList {
            
            guard let word = self.getWord(key: id) else { fatalError("Fatal Error: identifier cannot find match Word")
            }
            
            words.append(word)
        }
        
        return words
    }
    
    func reset() {
        orderList.removeAll()
        pendingList.removeAll()
        wordDictionary.removeAll()
    }
}
