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
    
    init(networkManager: FirebaseManager = .init()) {
        self.networkManager = networkManager
    }
    
    func listen<T: Codable>(env: FirebaseManager.Environment, orderBy order: FirebaseManager.Order, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        
        networkManager.listen(env) { (db) in
            db.order(by: order.rawValue, descending: true).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    
                    completion(.failure(.noData(error)))
                    
                } else {
                    
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
        
        var copied:[T] = datas
        
        while !copied.isEmpty {
            guard
                var dailyWord = (copied as? [DailyWord]),
                let id = dailyWord.popLast()?.id else { return }
            
            copied.removeLast()
            
            dailyWordManager.append(id: id)
            
            fetchWord(id: id)
            
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
}
