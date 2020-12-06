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
        
    var updateHot5: (() -> Void )?
    
    func fetchData(in collection: FirebaseCollection) {
       
        switch collection {
        
        case .word:
            
            break

        case .definition:
            
            break
            
        case .user:
            
            networkManager.listen(collection: collection.name) { (result: Result<[User], Error>) in
                
                switch result {
                
                case .success(let users):
                    
                    self.userViewModels.value = users
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                    
                }
            }
            
        }
    }
}

enum FirebaseCollection {
    
    case word, definition, user

}

extension FirebaseCollection {
    
    var name: String {
        switch self {
        case .word:
            return "Word"
        case .definition:
            return "Definition"
        case .user:
            return "User"
        }
    }
}

enum Carousel: CaseIterable {
    
    case mostViewedWord, newestWord
    
    func getImage() -> String {
        switch self {
        case .mostViewedWord:
            return ImageConstant.top5
        case .newestWord:
            return ImageConstant.newWordsLogo
        }
    }
}
