//
//  UserViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/16/20.
//

import UIKit

class UserViewModel {
    
    private let networkManager: FirebaseManager
    
    var challenges: [Challenge] = [.view, .like, .post]
    
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
            networkManager.updateChallenge(uid: uid, challenge: .view(0)) {
                completion()
            }
        case .like:
            networkManager.updateChallenge(uid: uid, challenge: .like(0)) {
                completion()
            }
        case .post:
            networkManager.updateChallenge(uid: uid, challenge: .post(0)) {
                completion()
            }
        }
    }
    
}

extension UserViewModel {
    
    enum Challenge {
        case like, view, post
    }
    
    enum Stage: String {
        
        case begin, process, finish
        
    }
    
    struct ProgressBar {
        
        let title: String
        
        let color: UIColor
    }
    
    class Process {
        
        let currentStage: Int
        
        let challenge: Challenge
        
        var hasDrawed: Bool = false
        
        init(currentStage: Int, challenge: Challenge) {
            self.currentStage = currentStage
            self.challenge = challenge
        }
        
        func drawed() {
            hasDrawed = true
        }
        
        var stage: Stage {
            switch self.currentStage {
            case -1:
                return .begin
            case 0 ... 9:
                return .process
            default:
                return .finish
            }
        }
    }
    
    func getProcess(at challenge: Challenge, currentStage: Int) -> Process {
        
        return Process(currentStage: currentStage, challenge: challenge)
        
    }
    
    func getProgressBar(_ challenge: Challenge) -> ProgressBar {
        
        let progressBar: ProgressBar
        
        switch challenge {
        
        case .like:
            
            progressBar = ProgressBar(title: "按讚挑戰賽", color: .systemGreen)
            
        case .view:
            
            progressBar = ProgressBar(title: "幹話探索挑戰賽", color: .systemYellow)
            
        case .post:
            
            progressBar = ProgressBar(title: "發文挑戰賽", color: .separatorlineBlue)
            
        }
        
        return progressBar
    }
}
