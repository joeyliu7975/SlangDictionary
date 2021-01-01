//
//  DailyViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/23/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class DailyWordViewModel {
    
    let networkManager: FirebaseManager
    
    let dailyViewModels = Box([Word]())
    
    let dailyWordManager = DailyWordManager<Word>()
    
    var dailyData: [DailyWord] = []
    
    init(networkManager: FirebaseManager = .init()) {
        self.networkManager = networkManager
    }
    
    func listen<T: Codable>(env: Environment, orderBy order: FirebaseManager.Order, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        
        networkManager.listen(env) { (db) in
            db.order(by: order.rawValue, descending: true).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    
                    completion(.failure(.noData(error)))
                    
                } else {
                    
                    self.reset()
                    
                    var datas = [T]()
                    
                    for document in querySnapshot!.documents {
                        if let data = try? document.data(as: T.self, decoder: Firestore.Decoder()) {
                            datas.append(data)
                        } else {
                            completion(.failure(.decodeError))
                        }
                    }
                    
                    completion(.success(datas))
                }
            }
        }
    }
    
    func handle<T: Codable>(_ datas: [T]) {
        
        if let dailys = datas as? [DailyWord] {
            self.dailyData  = dailys
        }
        
        var copied:[T] = datas
        
        while !copied.isEmpty {
            guard
                let id = (copied as? [DailyWord])?.first?.id else { return }
            
            dailyWordManager.append(id: id)
            
            fetchWord(id: id)
            
            copied.removeFirst()
        }

    }
    
    func fetchWord(id: String) {
        
        networkManager.retrieveWord(id: id) { (result: Result<Word, NetworkError>) in
            switch result {
            case .success(let word):
               
                self.dailyWordManager.add(key: id, value: word)
                
                self.dailyWordManager.removeLastPending()
                                            
                if self.dailyWordManager.pendingsIsEmpty {
                    self.orderWords()
                }
                
            case .failure(.noData(let error)):
                
                print(error.localizedDescription)
                
            case .failure(.decodeError):
                
                print("Decode Error!")
                
            }
        }
    }
}

extension DailyWordViewModel {
    func orderWords() {
        
        let words = dailyWordManager.organizeWords()
        
        self.dailyViewModels.value = words
    }
    
    func reset() {
        dailyWordManager.reset()
    }
}
