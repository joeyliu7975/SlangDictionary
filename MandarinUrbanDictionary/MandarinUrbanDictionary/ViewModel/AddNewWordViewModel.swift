//
//  AddNewWordViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/5/20.
//

import Foundation

class AddNewWordViewModel {
    
    let categoryList: [Category] = [
        .engineer,
        .job,
        .school,
        .pickUpLine,
        .restaurant,
        .game,
        .gym,
        .relationship
    ]
    
    let networkManager: FirebaseManager = .init()
    
    var isEnable: Bool = false {
        didSet {
            updateStatus?(isEnable)
        }
    }
    
    var updateStatus: ((Bool) -> Void)?
    
    func createNewWord(word: String?, definition: String?, category: String?, completion: () -> Void) {
        
        guard
            let word = word,
            let userDefinition = definition,
            let category = category
        else {
            return
        }
        
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
            content: userDefinition,
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
    
    func containEmptyString(newWord: String?, definition: String?, category: String?, completion: @escaping (Bool) -> Void) {
        
        guard
            let word = newWord,
            let definition = definition,
            let category = category
        else {
            return
        }
        
        let texts = [word, definition, category]
        
        switch texts.contains("") {
        case true:
            completion(false)
        case false:
            completion(true)
        }
    }
    
    func pickerView(selectRowAs text: String?) -> String {
        guard let text = text,
              !text.isEmpty
              else {
            return categoryList[0].instance().name
        }
        
        return text
    }
    
}
