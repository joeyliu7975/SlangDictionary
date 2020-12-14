//
//  AddNewWordViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/5/20.
//

import Foundation

class AddNewWordViewModel {
    
    let categoryList = Category.allCases
    
    let networkManager: FirebaseManager = .init()
    
    var isEnable: Bool = false {
        didSet {
            updateStatus?(isEnable)
        }
    }
    
    var updateStatus: ((Bool) -> Void)?
    
    func createNewWord(word: String, definition: String, category: String, completion: () -> Void) {
        
        let wordID = String.makeID()
        
        let defID = String.makeID()
        
        let newWord = Word(
            title: word,
            category: category,
            views: 0,
            identifier: wordID,
            time: FirebaseTime()
        )
        
        let definition = Definition(
            content: definition,
            like: [String](),
            dislike: [String](),
            identifier: defID,
            time: FirebaseTime(),
            idForWord: wordID
        )
        
        networkManager.createNewWord(
            word: newWord,
            def: definition,
            completion: completion
        )
       
    }
    
    func containEmptyString(_ texts: [String]) -> Bool {
        if texts.contains("") {
            return false
        } else {
            return true
        }
    }
}
