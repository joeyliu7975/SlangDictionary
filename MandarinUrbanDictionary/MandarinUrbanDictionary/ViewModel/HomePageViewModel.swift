//
//  HomePageViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/26/20.
//

import Foundation

class HomePageViewModel {
    
    var cellCount: Int {
        
        let carouselList = Carousel.allCases
        
        return carouselList.count
    }
    
    private var networkManager: FirebaseManager = .init()
    
    var updateData: (() -> Void)?
    
    var userViewModels = Box([User]())
    
    var collectionViewImage = ["whats_new", "top5"]
        
    var updateHot5: ( () -> Void )?
    
    func fetchData(in collection: FirebaseCollection) {
       
        switch collection {
        
        case .word:
            
            break

        case .definition:
            
            break
            
        case .user:
            
            networkManager.listen(collection: collection.name) { (result:Result<[User], Error>) in
                
                switch result {
                
                case .success(let users):
                    
                    self.userViewModels.value = users
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                    
                }
                
                self.updateData?()
            }
            
        }
    }
}

extension HomePageViewModel {
    func renderCell(at carousel: Carousel) -> IndexPath {
        
        switch carousel {
        
        case .mostViewedWord:
            
            return IndexPath(row: 0, section: 0)
            
        case .newestWord:
            
            return IndexPath(row: 1, section: 0)
            
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
    
}
