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
    
    var rotateButton: ((Bool) -> Void)?
        
    var updateHot5: (() -> Void )?
    
    var isVertical: Bool = false {
        didSet {
            rotateButton?(isVertical)
        }
    }
    
    func fetchData(in collection: FirebaseManager.Collection) {
       
        switch collection {
        
        case .word:
            
            break

        case .definition(let id):
            
            networkManager.listen(collection) { (result: Result<[Word], Error>) in
                
                switch result {
                
                case .success(let words):
                    
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
        case .time:
            break
        case .report:
            break
        }
    }
}

enum Carousel: CaseIterable {
    
    case mostViewedWord, newestWord, dailyWord
    
    func getImage() -> String {
        switch self {
        case .mostViewedWord:
            return ImageConstant.top5
        case .newestWord:
            return ImageConstant.newWordsLogo
        case .dailyWord:
            return "Daily Words"
        }
    }
}
