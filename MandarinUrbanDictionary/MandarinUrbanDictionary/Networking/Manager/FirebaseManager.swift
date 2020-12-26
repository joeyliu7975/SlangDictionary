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

typealias Handler<T: Codable> = (Result<T, NetworkError>) -> Void

class FirebaseManager {
    
    typealias Handler = (CollectionReference) -> Void
    
    private let dataBase: Firestore

    init(_ dataBase: Firestore = Firestore.firestore()) {
        self.dataBase = dataBase
    }
    
    func listen<T: CollectionReference>(_ env: Environment, completion: @escaping (T) -> Void) {
        let db = adapted(env)
        
        if let db = db as? T {
            completion(db)
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
        
        let db = adapted(.word)
        
        db.document(doc).updateData( ["check_times": views])
        
        completion()
    }
    
    func updateLike(defID: String, isLike: Bool, completion: @escaping (() -> Void)) {
        
        guard let uid = UserDefaults.standard.value(forKey: "uid") else { return }
        
        let db = adapted(.definition)
        
        switch isLike {
        case true:
            db.document(defID).updateData(["like": FieldValue.arrayUnion([uid])])
        case false:
            db.document(defID).updateData(["like": FieldValue.arrayRemove([uid])])
        }
        
        completion()
    }
    
    func updateDislike(defID: String, isDislike: Bool, completion: @escaping (() -> Void)) {
        
        guard let uid = UserDefaults.standard.value(forKey: "uid") else { return }
        
        let db = adapted(.definition)
        
        switch isDislike {
        case true:
            db.document(defID).updateData(["dislike": FieldValue.arrayUnion([uid])])
        case false:
            db.document(defID).updateData(["dislike": FieldValue.arrayRemove([uid])])
        }
        
        completion()
    }
    
    func updateFavorite(userID: String, wordID: String, action: FavoriteStauts) {
        
        let db = adapted(.user)
        
        switch action {
        case .add:
            db.document(userID).updateData(["favorite_words": FieldValue.arrayUnion([wordID])])
        case .remove:
            db.document(userID).updateData(["favorite_words": FieldValue.arrayRemove([wordID])])
        }
    }
    
    func createNewWord(word: Word, def: Definition, completion: () -> Void) {
        
        let db = adapted(.word)
        
        db.document(word.identifier).setData(word.dictionary)
        
        createNewDef(def: def, completion: completion)
    }
    
    func createNewDef(def: Definition, completion: () -> Void) {
        
        let db = adapted(.definition)
        
        db.document(def.identifier).setData(def.dictionary)
        
        completion()
    }
    
    func retrieveUser<T: Codable>(userID: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let db = adapted(.user)
        
        db.document(userID).getDocument { (querySnapshot, error) in
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
        
        let db = adapted(.word)
        
        db.document(id).getDocument { (querySnapshot, error) in
            
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
        let db = adapted(.user)
        
        db.document(uid).updateData([arrayName: FieldValue.arrayRemove([wordID])])
    }
    
    func updateArray(uid: String, wordID: String, arrayName: String) {
        
        let db = adapted(.user)
        
        db.document(uid).updateData([arrayName: FieldValue.arrayUnion([wordID])])
    }
    
    func updateChallenge(uid: String, challenge: Challenge, completion: (() -> Void)? = nil) {
        
        let db = adapted(.user)
        
        var data = [String: Any]()
        
        switch challenge {
        case .view(let value):
            data[challenge.name] = value
        case .post(let value):
            data[challenge.name] = value
        case .like(let value):
            data[challenge.name] = value
        }
        
        db.document(uid).updateData(data) { err in
            
            if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    completion?()
                }
        }
    }
}
// Report
extension FirebaseManager {
    func report(_ report: Report) {
        
        let db = adapted(.definition)
        
        db.document(report.id).collection("Report").document(report.uid).setData(report.dictionary)
    }
}

extension FirebaseManager {
    private func adapted(_ env: Environment) -> CollectionReference {
        return dataBase.collection(env.rawValue)
    }
    
    func sendRequest(_ env: Environment, handler: Handler) {
        let request = adapted(env)
        
        handler(request)
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
    
    enum Order: String {
        case time = "created_time"
        case view = "check_times"
        case dailyTime = "today"
    }
    
    // Setup Collection Environment
    
    enum Environment: String {
        case dailyWorld = "DailyWord"
        case user = "User"
        case definition = "Definition"
        case word = "Word"
    }
    
    enum Challenge {
        case view(Int)
        case post(Int)
        case like(Int)

        var name: String {
            switch self {
            case .view(_):
                return "view_challenge"
            case .post(_):
                return "post_challenge"
            case .like(_):
                return "like_challenge"
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
