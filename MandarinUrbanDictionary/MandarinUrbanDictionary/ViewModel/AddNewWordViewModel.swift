//
//  AddNewWordViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/5/20.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

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
    let categories: [Category]
    
    let networkManager: FirebaseManager
    
    let group = DispatchGroup()
    
    var existedWordTitles = [String]()
    
    init(
        _ networkManager: FirebaseManager = .init(),
        categories: [Category] = [
        .engineer,
        .job,
        .school,
        .pickUpLine,
        .restaurant,
        .game,
        .gym,
        .relationship
    ]) {
        self.networkManager = networkManager
        self.categories = categories
    }
    
    var isEnable: Bool = false {
        didSet {
            updateStatus?(isEnable)
        }
    }
    
    var updateStatus: ((Bool) -> Void)?
}
// Network Request
extension AddNewWordViewModel {
    
    func create(word: String?, definition: String?, category: String?, completion: @escaping (Bool) -> Void) {
        
        guard
            let word = word,
            let def = definition,
            let category = category else { return }
        
        let wid = String.makeID()
        
        let defid = String.makeID()
        
        let newWord = Word(title: word, category: category, id: wid)
        
        let definition = Definition(content: def, id: defid, wid: wid)
        
        switch existedWordTitles.contains(word) {
        case true:
            
            completion(false)
            
            return
            
        case false:
            group.enter()
            
            networkManager.sendRequest(.word) { (db) in
                db.document(wid).setData(newWord.dictionary)
                
                group.leave()
            }
        }
        
        group.enter()
        
        networkManager.sendRequest(.definition) { (db) in
            db.document(defid).setData(definition.dictionary)
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(true)
        }
    }
}

extension AddNewWordViewModel {
    
    private func getUser<T: Codable>(completion: @escaping Handler<T>) {
        if let uid = UserDefaults.standard.string(forKey: "uid") {
            networkManager.sendRequest(.user) { (db) in
                db.document(uid).getDocument { (querySnapshot, error) in
                    if let error = error {
                        completion(.failure(.noData(error)))
                    } else {
                        if let data = try? querySnapshot?.data(as: T.self, decoder: Firestore.Decoder()) {
                            completion(.success(data))
                        } else {
                            completion(.failure(.decodeError))
                        }
                    }
                }
            }
        }
    }
    
    func updateChallenge(completion: @escaping () -> Void) {
        self.getUser { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                if user.postChallenge > -1 && user.postChallenge < 10 {
                    let postChallenge = user.postChallenge + 1
                    
                    self.networkManager.updateChallenge(uid: user.identifier, challenge: .post(postChallenge), completion: completion)
                }
                
                completion()
                
            case .failure(.decodeError):
                
                print("Decode")
                
            case .failure(.noData(let error)):
                
                print(error.localizedDescription)
                
            }
        }
    }
}

extension AddNewWordViewModel {
    
    func containEmptyString(newWord: String?, definition: String?, category: String?, completion: @escaping (Bool) -> Void) {
        
        guard
            let word = newWord,
            let definition = definition,
            let category = category
        else {
            return
        }
        
        let texts = [word, definition, category]
        
        switch texts.contains(String.emptyString) {
        
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
            return categories[0].instance().name
        }
        
        return text
    }
    
    func categoryName(at row: Int) -> String {
        let category = categories[row].instance()
        
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
