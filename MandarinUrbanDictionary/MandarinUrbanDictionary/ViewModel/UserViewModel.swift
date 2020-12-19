//
//  UserViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import Foundation

class UserViewModel {
    
    private let networkManager: FirebaseManager
    
    var allWords = Box([Word]())
    
    init(networkManager: FirebaseManager = .init()) {
        self.networkManager = networkManager
    }
    
    var discoveredWords = [String]() {
        didSet {
            fetchAllWords()
        }
    }
    
    func startDownloading() {
        fetchUserDiscoverWords()
    }
    
    func fetchAllWords() {
        networkManager.retrieveData(.word(orderBy: .time)) { (result: Result<[Word], Error>) in
            switch result {
            case .success(let words):
                
                self.allWords.value = words
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUserDiscoverWords() {
        
        guard let uid = UserDefaults.standard.value(forKey: "uid") as? String else { return }
        
        networkManager.retrieveUser(userID: uid) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                self.discoveredWords = user.discoveredWords
            case .failure(.noData(let error)):
                print(error.localizedDescription)
            case .failure(.decodeError):
                print("Decode Error")
            }
        }
    }
}
