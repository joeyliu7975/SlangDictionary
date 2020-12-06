//
//  AddNewWordViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/5/20.
//

import Foundation

class AddNewWordViewModel {
    
    let categoryList = Category.allCases
    
    var isEnable: Bool = false {
        didSet {
            updateStatus?(isEnable)
        }
    }
    
    var updateStatus: ((Bool) -> Void)?
    
    func createNewWord(word: String, definition: String, category: String) -> Word {
        
        let newWord = Word(
            name: word,
            definition: [definition],
            category: category,
            view: 0,
            identifier: "1234567890",
            time: FirebaseTime()
        )
        
        return newWord
        
    }
    
    func containEmptyString(_ texts: [String]) -> Bool {
        if texts.contains("") {
            return false
        } else {
            return true
        }
    }
}
