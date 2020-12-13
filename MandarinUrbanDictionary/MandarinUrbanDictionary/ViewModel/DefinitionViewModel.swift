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
    
    var isFavorite: Bool = false {
        didSet {
            updateData?()
        }
    }
    
    var updateData: (() -> Void)?
    
    init(id: String, word: String) {
        
        self.wordIdentifier = id
        
        self.word = word
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
    
    func checkFavorite() {
        
        if let userID = UserDefaults.standard.value(forKey: "uid") as? String {
            
            networkManager.retrieveUser(userID: userID, wordID: wordIdentifier) { (result: Result<User?, Error>) in
                
                switch result {
                case .success(let user):
                    self.isFavorite = (user == nil) ? false : true
                case .failure(let error):
                    print(error.localizedDescription)
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
            
            rankString = "Top Definition"
            
        default:
            
            rankString = String(describing: rank + 1)
            
        }
        
        return rankString
    }
}
