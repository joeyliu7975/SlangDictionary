//
//  FavoriteManager.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/23/20.
//

import Foundation

final class FavoriteManager<T> {
    
    typealias Value = T
    
    private var orderList = [String]()
    
    private var pendingList = [String]()
    
    private var wordDictionary = [String: Value]()
    
    var deleteButtonEnable: ((Bool) -> Void)?
    
    private func getWord(key: String) -> Value? {
        guard let word = wordDictionary[key] else { return nil }
        return word
    }
}

extension FavoriteManager: Organizer {
    
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
    
    func getType(with title: String) -> ListType {
        return ListType(rawValue: title) ?? .favorite
    }
}

extension FavoriteManager {
    
    enum ListType: String {
        case favorite = "我的最愛"
        case recent = "歷史紀錄"
        
        func getName() -> String {
            switch self {
            case .favorite:
                return "favorite_words"
            case .recent:
                return "recent_search"
            }
        }
    }
}

protocol Organizer {
    
    associatedtype Value
    
    var pendingsIsEmpty: Bool { get }
    
    func append(id: String)
    
    func add(key: String, value: Value)
    
    func organizeWords() -> [Value]
    
    func removeLastPending()
    
    func reset()
    
}
