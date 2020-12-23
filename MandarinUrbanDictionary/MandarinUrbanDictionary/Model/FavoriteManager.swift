//
//  FavoriteManager.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/23/20.
//

import Foundation

class FavoriteManager<T> {
    private var orderList = [String]()
    
    private var pendingList = [String]()
    
    private var wordDictionary = [String: T]()

    var deleteButtonEnable: ((Bool) -> Void)?
    
    var pendingsIsEmpty: Bool {
        return pendingList.isEmpty
    }
    
    func append(id: String) {
        orderList.append(id)
        
        pendingList.append(id)
    }
    
    func add(key: String, value: T) {
        wordDictionary[key] = value
    }
    
    func removeLastPending() {
        pendingList.removeLast()
    }
    
    func organizeWords() -> [T] {
        var words = [T]()
        
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
    
    private func getWord(key: String) -> T? {
        guard let word = wordDictionary[key] else { return nil }
        return word
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
