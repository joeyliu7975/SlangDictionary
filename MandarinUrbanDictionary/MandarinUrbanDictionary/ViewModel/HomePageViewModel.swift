//
//  HomePageViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/26/20.
//

import Foundation

class HomePageViewModel {
    
    let carouselList = Carousel.allCases
    
    private let networkManager: FirebaseManager = .init()
    
    var userViewModels = Box([User]())
            
    var wordViewModels = Box([Word]())

    var topFiveWords = [Word]()
    
    var newestWord = [Word]()
                
    var loadForFirstTime: (() -> Void)?
        
    private let group: DispatchGroup = .init()
    
    var dataHasReloaded: Bool = false {
        didSet {
            group.leave()
            
            loadForFirstTime?()
        }
    }
    
    var randomNumber = 12
    
    func listen(in collection: FirebaseManager.Collection) {
        switch collection {
        
        case .word(let order):
            
            networkManager.listen(.word(orderBy: order)) { (result: Result<[Word], Error>) in
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
        default :
            break
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
