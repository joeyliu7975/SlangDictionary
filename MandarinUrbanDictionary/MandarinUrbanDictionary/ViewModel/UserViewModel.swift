//
//  UserViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import Foundation

class UserViewModel {
    
    private let networkManager: FirebaseManager
    
    let challenges: [Challenge] = [.view, .favorite, .post]
    
    var allWords = Box(User.self)
    
    init(networkManager: FirebaseManager = .init()) {
        self.networkManager = networkManager
    }
    
    func fetchUser() {
        
    }
    
}

extension UserViewModel {
    enum Challenge {
        case favorite, view, post
    }
    
    func getTitle(_ challenge: Challenge) -> String {
        let title: String
        
        switch challenge {
        case .favorite:
            title = "10字收藏挑戰"
        case .view:
            title = "10字探索挑戰"
        case .post:
            title = "10字發文挑戰"
        }
        
        return title
    }
}
