//
//  UserFIRManager.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 1/1/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol FirebaseRequesting {
    
    associatedtype Element: Codable
    
    var database: Firestore { get set }
    
    func listen(completion: @escaping (Result<[Element], NetworkError>) -> Void)
    
    func retrieveData(completion: @escaping (Result<Element, NetworkError>) -> Void)
}

enum Environment: String {
    case dailyWorld = "DailyWord"
    case user = "User"
    case definition = "Definition"
    case word = "Word"
}

class UserFIRManager: FirebaseRequesting {
    typealias Element = User
    
    var database = Firestore.firestore()
    
    private let collection: Environment = .user
    
    let uid: String
    
    let field: String
    
    init(uid: String, field: String) {
        self.uid = uid
        self.field = field
    }
    
    func listen(completion: @escaping (Result<[Element], NetworkError>) -> Void) {
        database
            .collection(collection.rawValue)
            .document(uid)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(.noData(error)))
                } else {
                    
                    var datas = [Element]()
                    
                    if let data = try? querySnapshot!.data(as: Element.self, decoder: Firestore.Decoder()) {
                        
                        datas.append(data)
                        
                    } else {
                        completion(.failure(.decodeError))
                    }
                    
                    completion(.success(datas))
                }
            }
    }
    
    func retrieveData(completion: @escaping (Result<Element, NetworkError>) -> Void) {
        database.collection(collection.rawValue).document(uid).getDocument { (querySnapshot, error) in
            if let error = error {
                
                completion(.failure(.noData(error)))
                
            } else {
                
                if let data = try? querySnapshot?.data(as: Element.self, decoder: Firestore.Decoder()) {
                    completion(.success(data))
                }
            }
        }
    }
    
}
