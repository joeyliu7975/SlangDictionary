//
//  AddNewWordViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/5/20.
//

import Foundation
import Firebase

class AddNewWordViewModel {
    
    let categoryList = Category.allCases
    
    var buttonIsValid: Bool = false {
        didSet {
            updateConfirmButton?(buttonIsValid)
        }
    }
    
    var updateConfirmButton: ((Bool) -> Void)?
    
    func createNewWord(word: String, definition: String, category: String) -> Word {
        
        let newWord = Word(
            name: word,
            definition: [definition],
            category: category,
            view: 0,
            identifier: "1234567890",
            time: Timestamp()
        )
        
        return newWord
        
    }
}
