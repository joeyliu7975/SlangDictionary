//
//  DefinitionViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import Foundation
import AVFoundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class DefinitionViewModel {
    
    private let networkManager: FirebaseManager
        
    let wordIdentifier: String
    
    let word: String
    
    let category: String
    
    private var uid: String {
        return UserDefaults.standard.string(forKey: "uid") ?? ""
    }
    
    var isFavorite: Bool = false {
        didSet {
            updateData?()
        }
    }
    
    var updateData: (() -> Void)?
    
    init(id: String, word: String, category: String, networkManager: FirebaseManager = .init()) {
        
        self.wordIdentifier = id
        
        self.word = word
        
        self.category = category
        
        self.networkManager = networkManager
    }
        
    var definitionViewModels = Box([Definition]())
        
    func listenDefinitions() {
        networkManager.listen(.definition(self.wordIdentifier)) { (result: Result<[Definition], Error>) in
            switch result {
            case .success(let definitions):
                
                let sortedDefinition = definitions.sorted { $0.like.count > $1.like.count }
                
                self.definitionViewModels.value = sortedDefinition
                
            case .failure(let error):
                
                print("Fatal Error with: \(error.localizedDescription)")
                
            }
        }
        
        networkManager.listenSingleDoc(.user(uid)) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let data):
                
                let isFavorite = data.favorites.contains(self.wordIdentifier)
                    
                self.isFavorite = isFavorite

            case .failure(.noData(let error)):
                print(error.localizedDescription)
            case .failure(.decodeError):
                print("Decode Error")
            }
        }
    }
    
    func renewRecentSearch(completion: @escaping () -> Void) {
        
        networkManager.retrieveUser(userID: uid) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                
                if user.recents.contains(self.wordIdentifier) {
                    self.removeFromRecentSearch(completion: completion)
                }
                
                self.updateChallenge(.view)
                
                completion()
                
            case .failure(.noData(let error)):
                print(error.localizedDescription)
            case .failure(.decodeError):
                print("Decode Error!")
            }
        }
    }
    
    func discoverWord() {
        
        networkManager.updateArray(uid: uid, wordID: wordIdentifier, arrayName: "discovered_words")
        
    }
    
    func removeFromRecentSearch(completion: @escaping () -> Void) {
        
        networkManager.deleteArray(uid: uid, wordID: wordIdentifier, arrayName: "recent_search")
        
    }
    
    func addToRecentSearch() {
        
        networkManager.updateArray(uid: uid, wordID: wordIdentifier, arrayName: "recent_search")
            
    }
    
    func updateLikes(isLike: Bool, defID: String) {
        
        networkManager.updateLike(defID: defID, isLike: isLike) {
            
            self.updateChallenge(.like) {
                print("update Likes")
            }
            
        }

    }
    
    func updateDislikes(isDislike: Bool, defID: String) {
        
        networkManager.updateDislike(defID: defID, isDislike: isDislike) {
            print("update Dislikes")
        }
        
    }
    
    func checkFavorite(completion: @escaping (Bool) -> Void) {
        
        networkManager.retrieveUser(userID: uid) { (result: Result<User, NetworkError>) in
            
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
    
    func updateFavorites(action: FirebaseManager.FavoriteStauts, completion: @escaping (() -> Void)) {
        
            networkManager.updateFavorite(userID: uid, wordID: wordIdentifier, action: action) {
                completion()
            }
    }
    
    func convertRank(with rank: Int) -> String {
        
        var rankString: String
        
        switch rank {
        
        case 0:
            
            rankString = "最佳解釋"
            
        default:
            
            rankString = String(describing: rank + 1)
            
        }
        
        return rankString
    }
    
    func siriRead(_ word: String) {
        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        utterance.rate = 0.35

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

extension DefinitionViewModel {
    
    enum Challenge {
        case view, like
    }
    
    private func getUser<T: Codable>(completion: @escaping Handler<T>) {
        
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
    
    func updateChallenge(_ challenge: Challenge, completion: (() -> Void)? = nil) {
        
        self.getUser { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                
                self.handle(challenge, user: user, completion: completion)
                
            case .failure(.decodeError):
                
                print("Decode")
                
            case .failure(.noData(let error)):
                
                print(error.localizedDescription)
                
            }
        }
    }
    
    func handle(_ challenge: Challenge, user: User, completion: (() -> Void)? = nil) {
        switch challenge {
        
        case .like:
            if user.likeChallenge > -1 && user.likeChallenge < 10 {
                let likeChallenge = user.likeChallenge + 1
                
                self.networkManager.updateChallenge(uid: uid, challenge: .like(likeChallenge))
                
                completion?()
            }
        case .view:
            if user.viewChallenge > -1 && user.viewChallenge < 10 {
                let viewChallenge = user.viewChallenge + 1
                
                self.networkManager.updateChallenge(uid: uid, challenge: .view(viewChallenge))
                
                completion?()
            }
        }
    }
}
