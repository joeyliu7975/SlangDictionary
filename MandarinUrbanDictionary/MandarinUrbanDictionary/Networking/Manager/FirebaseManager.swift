//
//  FirebaseManager.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/4/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

typealias FirebaseTime = Timestamp

class FirebaseManager {
    
    private let dataBase: Firestore

    init(_ dataBase: Firestore = Firestore.firestore()) {
        self.dataBase = dataBase
    }

    func listen <T: Codable>(_ collection: Collection, completion: @escaping (Result<[T], Error>) -> Void) {
        
        switch collection {
        
        case .definition(let id):
            
            dataBase
                .collection(collection.name)
                .whereField("word_id", isEqualTo: id)
                .addSnapshotListener { (querySnapshot, error) in
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
        default:
            
            dataBase
                .collection(collection.name)
                .addSnapshotListener { (querySnapshot, error) in
                
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
    
    func retrieveData <T: Codable>(_ collection: Collection, with category: String? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        
        guard let category = category else {
            switch collection {
            case .word(let field):
                
                dataBase.collection(collection.name).order(by: field.rawValue, descending: true).getDocuments { (querySnapshot, error) in
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
                            
            default:
                
                dataBase.collection(collection.name).getDocuments { (querySnapshot, error) in
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
            return
        }
        
        dataBase.collection(collection.name).whereField("category", isEqualTo: category).getDocuments { (querySnapshot, error) in
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
    
    func updateViews(id doc: String, views: Int, completion: @escaping (() -> Void)) {
        
        dataBase.collection("Word").document(doc).updateData( ["check_times": views])
        
        completion()
        
    }
}

extension FirebaseManager {
    
    enum Collection {
        
        case definition(String)
        case word(orderBy: FirebaseManager.SortedBy)
        case user, time, report
        
        var name: String {
            switch self {
            case .definition:
                return "Definition"
            case .user:
                return "User"
            case .word:
                return "Word"
            case .time:
                return "viewed_time"
            case .report:
                return "report"
            }
        }
    }
    
    enum SortedBy: String {
        case views = "check_times"
        case time = "created_time"
    }
}
