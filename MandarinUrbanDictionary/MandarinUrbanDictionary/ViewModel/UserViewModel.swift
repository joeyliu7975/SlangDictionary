//
//  UserViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import UIKit

class UserViewModel {
    
    private let networkManager: FirebaseManager
    
    let challenges: [Challenge] = [.view, .favorite, .post]
    
    var processList: [Challenge: Process] = [:]
    
    var currentUser = Box([User]())
    
    init(networkManager: FirebaseManager = .init()) {
        self.networkManager = networkManager
    }
    
    func fetchUserStatus() {
        
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        
        networkManager.retrieveUser(userID: uid) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                self.currentUser.value = [user]
            case .failure(.decodeError):
                print("User Model decode Error!")
            case .failure(.noData(let error)):
                print(error.localizedDescription)
            }
        }
    }
       
    func startChallenge(challenge: Challenge, completion: @escaping () -> Void) {
        
        guard let uid = UserDefaults.standard.string(forKey: "uid") else { return }
        
        switch challenge {
        case .view:
            networkManager.updateChallenge(uid: uid, data: ["view_challenge": 0]) {
                completion()
            }
        case .favorite:
            networkManager.updateChallenge(uid: uid, data: ["favorite_challenge": 0]) {
                completion()
            }
        case .post:
            networkManager.updateChallenge(uid: uid, data: ["post_challenge": 0]) {
                completion()
            }
        }
    }
    
}

extension UserViewModel {
    
    enum Challenge {
        case favorite, view, post
    }
    
    enum Stage: String {
        
        case begin, process, finish
        
    }
    
    struct ProgressBar {
        
        let title: String
        
        let color: UIColor
    }
    
    struct Process {
        
        let currentStage: Int
        
        let challenge: Challenge
    }
    
    func getProcess(at challenge: Challenge, currentStage: Int) -> Process {
        return Process(currentStage: currentStage, challenge: challenge)
    }
    
    func getProgressBar(_ challenge: Challenge) -> ProgressBar {
        
        let progressBar: ProgressBar
        
        switch challenge {
        
        case .favorite:
            
            progressBar = ProgressBar(title: "10字收藏挑戰", color: .systemGreen)
            
        case .view:
            
            progressBar = ProgressBar(title: "10字探索挑戰", color: .systemYellow)
            
        case .post:
            
            progressBar = ProgressBar(title: "10字發文挑戰", color: .separatorlineBlue)
            
        }
        
        return progressBar
    }
    
    func getStage(currentStage: Int) -> Stage {
        switch currentStage {
        case -1:
            return .begin
        case 0 ... 9:
            return .process
        default:
            return .finish
        }
    }
    
}
