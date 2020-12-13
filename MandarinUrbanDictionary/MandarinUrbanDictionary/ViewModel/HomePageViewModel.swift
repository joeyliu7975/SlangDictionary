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
    
    var topFiveWords = [Word]() {
        didSet {
            
        }
    }
    
    var newestWord = [Word]() {
        didSet {
            
        }
    }
            
    var updateHot5: (() -> Void )?
    
    var loadForFirstTime: (() -> Void)?
    
    let group = DispatchGroup()
    
    var dataHasReloaded: Bool = false {
        didSet {
            group.leave()
            
            loadForFirstTime?()
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
        case .definition(_):
            
            break
            
        case .user:
            
            networkManager.listen(collection) { (result: Result<[User], Error>) in
                
                switch result {
                
                case .success(let users):
                    
                    self.userViewModels.value = users
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                    
                }
            }
        case .time:
            break
        case .report:
            break
        }
    }
}
