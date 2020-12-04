//
//  FirebaseManager.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/4/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseManager {
    
    private let dataBase: Firestore

    init(_ dataBase: Firestore = Firestore.firestore()) {
        self.dataBase = dataBase
    }

    func listen <T: Codable>(collection name: String, completion: @escaping (Result<[T], Error>) -> Void) {
        
        dataBase.collection(name).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                
                completion(.failure(error))
                
            } else {
                
                var datas = [T]()
                
                for document in querySnapshot!.documents {
                    if let data = try? document.data(as: T.self, decoder: Firestore.Decoder()) {
                        datas.append(data)
                    }
                }
                
                completion(.success(datas))
                
            }
        }
        
    }
}
