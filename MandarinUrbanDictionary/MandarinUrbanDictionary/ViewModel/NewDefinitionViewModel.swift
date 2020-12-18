//
//  NewDefinitionViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/14/20.
//

import Foundation

class NewDefinitionViewModel {
    
    let networkManager: FirebaseManager = .init()
    
    let wordID: String
    
    private var content: String?
    
    init(wordID: String) {
        self.wordID = wordID
    }
    
    func textViewContent(_ content: String) {
        self.content = content
    }
    
    func writeNewDefinition(completion: () -> Void) {
        
        guard let content = content else { return }
        
        let definition = Definition(
            content: content,
            like: [String](),
            dislike: [String](),
            identifier: String.makeID(),
            time: FirebaseTime(),
            idForWord: wordID
        )
        
        networkManager.createNewDef(def: definition, completion: completion)
    }
   
    
}
