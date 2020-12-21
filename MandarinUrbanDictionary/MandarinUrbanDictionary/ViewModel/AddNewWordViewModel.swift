//
//  AddNewWordViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/5/20.
//

import UIKit

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
    
    let networkManager: FirebaseManager
    
    let group = DispatchGroup()
    
    init(_ networkManager: FirebaseManager = .init()) {
        self.networkManager = networkManager
    }
    
    var isEnable: Bool = false {
        didSet {
            updateStatus?(isEnable)
        }
    }
    
    var updateStatus: ((Bool) -> Void)?
}

extension AddNewWordViewModel {
    
    func create(word: String?, definition: String?, category: String?, completion: @escaping () -> Void) {
        
        guard
            let word = word,
            let userDefinition = definition,
            let category = category else { return }
        
        let wordID = String.makeID()
        
        let defID = String.makeID()
        
        let newWord = Word(title: word, category: category, id: wordID)
        
        let definition = Definition(content: userDefinition, id: defID, wid: wordID)
        
        group.enter()
        
        group.enter()
        
        networkManager.sendRequest(.word) { (db) in
            db.document(wordID).setData(newWord.dictionary)
            
            group.leave()
        }
        
        networkManager.sendRequest(.definition) { (db) in
            db.document(defID).setData(definition.dictionary)
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
//    func createNewWord(word: String?, definition: String?, category: String?, completion: () -> Void) {
//
//        guard
//            let word = word,
//            let userDefinition = definition,
//            let category = category
//        else {
//            return
//        }
//
//        let wordID = String.makeID()
//
//        let defID = String.makeID()
//
//        let newWord = Word(
//            title: word,
//            category: category,
//            views: 0,
//            identifier: wordID,
//            time: FirebaseTime()
//        )
//
//        let definition = Definition(
//            content: userDefinition,
//            like: [String](),
//            dislike: [String](),
//            identifier: defID,
//            time: FirebaseTime(),
//            idForWord: wordID
//        )
//
//        networkManager.createNewWord(
//            word: newWord,
//            def: definition,
//            completion: completion
//        )
//    }
    
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
    
    func categoryName(at row: Int) -> String {
        let category = categoryList[row].instance()
        
        return category.name
    }
    
    func checkFormValidation(definitionStatus: UITextView.Content, definition: String?, newWord: String?, category: String?) {
        
        if definitionStatus == .placeHolder { return }

        containEmptyString(
            newWord: newWord,
            definition: definition,
            category: category
        ) { [weak self] (isEnable) in
            self?.isEnable = isEnable
        }
    }
}

extension AddNewWordViewModel {
    
    func updateChallenge(completion: (() -> Void)? = nil) {
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            networkManager.retrieveUser(userID: uid)  { [weak self] (result: Result<User, NetworkError>) in
                
                switch result {
                case .success(let user):
                    
                    if user.postChallenge > -1 && user.postChallenge < 10 {
                        let postChallenge = user.postChallenge + 1
                        
                        self?.networkManager.updateChallenge(uid: uid, data: ["post_challenge": postChallenge], completion: completion)
                    }
                    
                    completion?()
                    
                case .failure(.noData(let error)):
                    print(error.localizedDescription)
                case .failure(.decodeError):
                    print("Decode Error!")
                }
            }
        }
    }
}
