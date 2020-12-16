//
//  DefinitionViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import Foundation

class DefinitionViewModel {
    
    let networkManager: FirebaseManager = .init()
        
    let wordIdentifier: String
    
    let word: String
    
    let category: String
    
    var isFavorite: Bool = false {
        didSet {
            updateData?()
        }
    }
    
    var updateData: (() -> Void)?
    
    init(id: String, word: String, category: String) {
        
        self.wordIdentifier = id
        
        self.word = word
        
        self.category = category
    }
        
    var definitionViewModels = Box([Definition]())
    
    func listen() {
        networkManager.listen(.definition(self.wordIdentifier)) { (result: Result<[Definition], Error>) in
            switch result {
            case .success(let definitions):
                
                let sortedDefinition = definitions.sorted { $0.like.count > $1.like.count }
                
                self.definitionViewModels.value = sortedDefinition
                
            case .failure(let error):
                
                print("Fatal Error with: \(error.localizedDescription)")
                
            }
        }
    }
    
    func renewRecentSearch(completion: @escaping () -> Void) {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            networkManager.retrieveUser(userID: uid) { (result: Result<User, NetworkError>) in
                switch result {
                case .success(let user):
                    
                    if user.recents.contains(self.wordIdentifier) {
                        self.removeFromRecentSearch(completion: completion)
                    }
                    
                    completion()
                    
                case .failure(.noData(let error)):
                    print(error.localizedDescription)
                case .failure(.decodeError):
                    print("Decode Error!")
                }
            }
        }
    }
    
    func discoverWord() {
        
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            networkManager.updateArray(uid: uid, wordID: wordIdentifier, arrayName: "discovered_words")
        }
        
    }
    
    func removeFromRecentSearch(completion: @escaping () -> Void) {
        
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            networkManager.deleteArray(uid: uid, wordID: wordIdentifier, arrayName: "recent_search")
        }
        
    }
    
    func addToRecentSearch() {
        
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            networkManager.updateArray(uid: uid, wordID: wordIdentifier, arrayName: "recent_search")
        }
            
    }
    
    func updateLikes(isLike: Bool, defID: String) {
        
        networkManager.updateLike(defID: defID, isLike: isLike) {
            print("update Likes")
        }

    }
    
    func updateDislikes(isDislike: Bool, defID: String) {
        
        networkManager.updateDislike(defID: defID, isDislike: isDislike) {
            print("update Dislikes")
        }
        
    }
    
    func checkFavorite(completion: @escaping (Bool) -> Void) {
        
        if let userID = UserDefaults.standard.value(forKey: "uid") as? String {
            
            networkManager.retrieveUser(userID: userID) { (result: Result<User, NetworkError>) in
                
                switch result {
                case .success(let user):
                    
                    let isFavorite = user.favorites.contains(self.wordIdentifier)
                    
                    completion(isFavorite)
                    
                case .failure(.noData(let error)):
                    
                    print(error.localizedDescription)
                    
                case .failure(.decodeError):
                    
                    print("Decode Error!")
                    
                }
            }
        }
    }
    
    func updateFavorites(action: FirebaseManager.FavoriteStauts,completion: @escaping (() -> Void)) {
        
        if let userID = UserDefaults.standard.value(forKey: "uid") as? String {
            
            networkManager.updateFavorite(userID: userID, wordID: wordIdentifier, action: action) {
                completion()
            }
            
        }
    }
    
    func convertRank(with rank: Int) -> String {
        
        var rankString: String
        
        switch rank {
        
        case 0:
            
            rankString = "置頂解釋"
            
        default:
            
            rankString = String(describing: rank + 1)
            
        }
        
        return rankString
    }
}
