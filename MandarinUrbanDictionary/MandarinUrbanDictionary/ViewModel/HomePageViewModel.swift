//
//  HomePageViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/26/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class HomePageViewModel {
    
    let carouselList = Carousel.allCases
    
    private let networkManager: FirebaseManager
    
    init(networkManager: FirebaseManager = .init()) {
        self.networkManager = networkManager
    }
    
    var userViewModels = Box([User]())
            
    var wordViewModels = Box([Word]())

    var topFiveWords = [Word]()
    
    var newestWord = [Word]()
    
    var dailyWord: Word?
                
    var loadForFirstTime: (() -> Void)?
        
    private let group: DispatchGroup = .init()
    
    var dataHasReloaded: Bool = false {
        didSet {
            group.leave()
            
            loadForFirstTime?()
        }
    }
    
    var randomNumber = 12
    
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
    
    func handle<T: Codable>(_ res: Result<[T],NetworkError>) {
        switch res {
        
        case .success(let data):
            
            if let words = try data as? [Word] {
                
                self.topFiveWords = Array(words[0 ... 4])
                
                self.listenDailyWord { (id) in
                    let dailyWords = words.filter { $0.identifier == id }
                    
                    self.dailyWord = dailyWords.first
                    
                    self.wordViewModels.value = words
                }
            }
            
        case .failure(let error):
            
            print("fetchData.failure: \(error)")
            
        }
    }
    
    func listenDailyWord(completion: @escaping (String) -> Void) {
        
        networkManager.listenDailyWord { (result: Result<DailyWord, Error>) in
            switch result {
            case .success(let dailyWord):
                completion(dailyWord.id)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData(in collection: FirebaseManager.Collection) {
       
        switch collection {
        
        case .word(let order):
            
            networkManager.retrieveData(.word(orderBy: order)) { (result: Result<[Word], Error>) in
                switch result {
                
                case .success(let words):
                    
                    self.topFiveWords = Array(words[0 ... 4])
                    
                    self.wordViewModels.value = words
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                    
                }
            }
        case .user:
            
            networkManager.listen(collection) { (result: Result<[User], Error>) in
                
                switch result {
                
                case .success(let users):
                    
                    self.userViewModels.value = users
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                    
                }
            }
        default:
            break
        }
    }
}

extension HomePageViewModel {
    func makeRandomNumber() {
        guard !wordViewModels.value.isEmpty else { return }
        
        randomNumber = Int.random(in: 0 ..< wordViewModels.value.count)
        
    }
}

extension HomePageViewModel {
    enum Carousel: CaseIterable {
        
        case newestWord, mostViewedWord, dailyWord, randomWord
        
        func getImage() -> String {
            
            switch self {
            
            case .mostViewedWord:
                
                return ImageConstant.top5
                
            case .newestWord:
                
                return ImageConstant.newWordsLogo
                
            case .dailyWord:
                
                return ImageConstant.wordOfTheDay
                
            case .randomWord:
                
                return ImageConstant.randomWord
            }
        }
    }
}
