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
    
    // TEST Firebase Reuqest

    func listen<T>(request: Request, completion: @escaping (Result<[T], NetworkError>) -> Void) {
        print("Test")
//        dataBase.collection(request.collection)
        
    }
    
    // Original Firebase
    func listen<T: Codable>(_ collection: Collection, completion: @escaping (Result<[T], Error>) -> Void) {
        
        switch collection {
        
        case .word(let field):
            dataBase.collection(collection.name).order(by: field.rawValue, descending: true).addSnapshotListener { (querySnapshot, error) in
                
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
    
    func listenSingleDoc<T: Codable>(_ collection: Collection, completion: @escaping (Result<T, NetworkError>) -> Void) {
        switch collection {
        case .user(let id):
            dataBase
                .collection(collection.name)
                .document(id)
                .addSnapshotListener { (querySnapshot, error) in
                    if let error = error {
                        completion(.failure(.noData(error)))
                    } else {
                        if let data = try? querySnapshot!.data(as: T.self, decoder: Firestore.Decoder()) {
                            completion(.success(data))
                        } else {
                            completion(.failure(.decodeError))
                        }
                    }
                }
        default:
            break
        }
    }

    func listenDailyWord(completion: @escaping (Result<DailyWord, Error>) -> Void) {
        
        dataBase.collection("DailyWord").order(by: "today", descending: true).addSnapshotListener { (querySnapshot, error) in
            
            if let error = error {
                
                completion(.failure(error))
                
            }  else {
                var datas = [DailyWord]()
                
                for document in querySnapshot!.documents {
                    if let data = try? document.data(as: DailyWord.self, decoder: Firestore.Decoder()) {
                        datas.append(data)
                    }
                }
                
                completion(.success(datas.first!))
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
    
    func updateLike(defID: String, isLike: Bool, completion: @escaping (() -> Void)) {
        
        guard let uid = UserDefaults.standard.value(forKey: "uid") else { return }
        
        switch isLike {
        case true:
            dataBase.collection("Definition").document(defID).updateData(["like": FieldValue.arrayUnion([uid])])
        case false:
            dataBase.collection("Definition").document(defID).updateData(["like": FieldValue.arrayRemove([uid])])
        }
        
        completion()
    }
    
    func updateDislike(defID: String, isDislike: Bool, completion: @escaping (() -> Void)) {
        
        guard let uid = UserDefaults.standard.value(forKey: "uid") else { return }
        
        switch isDislike {
        case true:
            dataBase.collection("Definition").document(defID).updateData(["dislike": FieldValue.arrayUnion([uid])])
        case false:
            dataBase.collection("Definition").document(defID).updateData(["dislike": FieldValue.arrayRemove([uid])])
        }
        
        completion()
    }
    
    func updateFavorite(userID: String, wordID: String, action: FavoriteStauts, completion: @escaping (() -> Void)) {
        
        switch action {
        case .add:
            dataBase.collection("User").document(userID).updateData(["favorite_words": FieldValue.arrayUnion([wordID])])
        case .remove:
            dataBase.collection("User").document(userID).updateData(["favorite_words": FieldValue.arrayRemove([wordID])])
        }
        
        completion()
    }
    
    func createNewWord(word: Word, def: Definition, completion: () -> Void) {
        
        dataBase.collection("Word").document(word.identifier).setData(word.dictionary)
        
        createNewDef(def: def, completion: completion)
    }
    
    func createNewDef(def: Definition, completion: () -> Void) {
        
        dataBase.collection("Definition").document(def.identifier)
            .setData(def.dictionary)
        
        completion()
    }
    
    func retrieveUser<T: Codable>(userID: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        dataBase.collection("User").document(userID).getDocument { (querySnapshot, error) in
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
    
    func retrieveWord<T: Codable>(id: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        dataBase.collection("Word").document(id).getDocument { (querySnapshot, error) in
            
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
    
    func deleteArray(uid: String, wordID: String, arrayName: String) {
        dataBase.collection("User").document(uid).updateData([arrayName: FieldValue.arrayRemove([wordID])])
    }
    
    func updateArray(uid: String, wordID: String, arrayName: String) {
        dataBase.collection("User").document(uid).updateData([arrayName: FieldValue.arrayUnion([wordID])])
    }
}

extension FirebaseManager {
    
    enum Collection {
        
        case definition(String)
        case word(orderBy: FirebaseManager.SortedBy)
        case user(String)
        case time, report
        
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
    
    enum FavoriteStauts {
        case add, remove
    }
}

enum NetworkError: Error {
    case decodeError
    case noData(Error)
}

protocol FirebaseItem {
    
    associatedtype Item
    
    var dictionary: Item { get }
}
