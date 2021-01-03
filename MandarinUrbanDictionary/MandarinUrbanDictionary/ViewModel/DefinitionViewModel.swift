//
//  DefinitionViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol SpeakerDelegate: class {
    func speechDidFinish(_ sender: UIButton)
}

class DefinitionViewModel {
    
    typealias ResponseDatas<T: Codable> = (Result<[T], NetworkError>)
    
    typealias ResponseData<T:Codable> = (Result<T, Error>)
    
    private let networkManager: FirebaseManager
            
    let word: DefinitionViewModel.Word
    
    var reportedDefinition: String?
    
    var uid: String {
        return UserDefaults.standard.string(forKey: "uid") ?? String.emptyString
    }
    
    var isFavorite: Bool = false {
        didSet {
            updateData?()
        }
    }
    
    var updateData: (() -> Void)?
    
    init(id: String, word: String, category: String, networkManager: FirebaseManager = .init()) {
        
        self.word = Word(id: id, title: word, category: category)
                
        self.networkManager = networkManager
    }
        
    var definitionViewModels = Box([Definition]())
    
    var userViewModels = Box([User]())
    
    func renewRecentSearch(completion: @escaping () -> Void) {
    
        networkManager.retrieveUser(userID: uid) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):

                if user.recents.contains(self.word.id) {
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
        
        networkManager.updateArray(uid: uid, wordID: word.id, arrayName: "discovered_words")
        
    }
    
    func removeFromRecentSearch(completion: @escaping () -> Void) {
        
        networkManager.deleteArray(uid: uid, wordID: word.id, arrayName: "recent_search")
        
    }
    
    func addToRecentSearch() {
        
        networkManager.updateArray(uid: uid, wordID: word.id, arrayName: "recent_search")
            
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
                
                let isFavorite = user.favorites.contains(self.word.id)
                
                completion(isFavorite)
                
            case .failure(.noData(let error)):
                
                print(error.localizedDescription)
                
            case .failure(.decodeError):
                
                print("Decode Error!")
                
            }
        }
    }
    
    func updateFavorites(action: FirebaseManager.FavoriteStauts) {
        
        networkManager.updateFavorite(userID: uid, wordID: word.id, action: action)
        
        LocalNotificationManager.scheduleLocal(title: .favorite, body: "「\(word.title)」字義解釋:\n \(definitionViewModels.value.first!.content)", time: .evening, identifier: .favorite)
    }
    
    func getRankString(at rank: Int) -> String {
        
        return rank.rankString
        
    }
}

// Report
extension DefinitionViewModel {
    func report(id: String, reason: String, completion: @escaping () -> Void) {
        let report = Report(uid: uid, id: id, reason: reason)
        
        networkManager.report(report, completion: completion)
    }
}

extension DefinitionViewModel {
    func checkUserOpinion(on status: UserOpinion) -> Bool {
        
        let uid = self.uid
        
        var isLike: Bool
        
        switch status {
        case .like(let index):
            let definition = self.definitionViewModels.value[index]
                
           isLike = definition.like.contains(uid)
            
        case .dislike(let index):
            
            let definition = self.definitionViewModels.value[index]
                
           isLike = definition.dislike.contains(uid)
        }
        
        return isLike
    }
}

// Observe Definition Collection
extension DefinitionViewModel {
    func listenDefinitions<T: Codable>(completion: @escaping (Result<[T], NetworkError>) -> Void) {
        
        networkManager.listen(.definition) { (db) in
            db.whereField("word_id", isEqualTo: self.word.id).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    
                    var datas = [T]()
                    
                    for document in querySnapshot!.documents {
                        if let data = try? document.data(as: T.self, decoder: Firestore.Decoder()) {
                            datas.append(data)
                        } else {
                            print("Decode Error!")
                        }
                    }
                    
                    completion(.success(datas))
                    
                }
            }
        }
    }
    
    func listenUser<T: Codable>(completion: @escaping (Result<T,Error>) -> Void) {
        
        let uid = self.uid
        
        networkManager.listen(.user) { (db) in
            db.document(uid).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                        if let data = try? querySnapshot!.data(as: T.self, decoder: Firestore.Decoder()) {
                            completion(.success(data))
                        } else {
                            print("Decode Error!")
                        }
                    
                }
            }
        }
    }
    
    func handle<T: Codable>(_ res: ResponseDatas<T>) {
        
        switch res {
        case .success(let data):
            if let defs = data as? [Definition] {
                let sortedDefinition = defs.sorted { $0.like.count > $1.like.count }
                
                self.definitionViewModels.value = sortedDefinition
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func handle<T: Codable>(_ res: ResponseData<T>) {
        switch res {
            case .success(let data):
                if let user = data as? User {
                    if user.favorites.contains(word.id) {
                        isFavorite = true
                    } else {
                        isFavorite = false
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
        }
    }
}
// Update User's Challenge Field
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

extension DefinitionViewModel {
    struct Word {
        let id: String
        
        let title: String
        
        let category: String
    }
    
    enum UserOpinion {
        case like(Int)
        case dislike(Int)
    }
}
