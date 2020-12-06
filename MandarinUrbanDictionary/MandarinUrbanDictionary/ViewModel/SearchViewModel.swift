//
//  SearchViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/6/20.
//

import Foundation

class SearchViewModel {
    
    var result = Box([Word]())
    
    var updateTitle: ((String) -> Void)?
    
    var showSearchResult: (() -> Void)?
        
    private var selectedCategory: Category = .all {
        didSet {
            
            let title = barTitle
            
            updateTitle?(title)
        }
    }
    
    var barTitle: String {
        return selectedCategory.instance().name
    }
    
    private let networkManager: FirebaseManager = .init()
    
    func search(keyword: String) {
        
        networkManager.retrieveData(.word) { [weak self] (result: Result<[Word], Error>) in
            
            switch result {
            
            case .success(let words):
                
                self?.filter(words, with: keyword)
                
            case .failure(let error):
                
                print("Fatal Error with: \(error.localizedDescription)")
            }
            
        }
    }
    
    func filter(_ data: [Word], with keyword: String) {
        
        var filtered = [Word]()
            
        keyword.forEach { (character) in
            
            filtered = data.filter { (word) -> Bool in
                return word.title.contains(character)
            }
            
        }
        
        result.value = filtered
        
    }
    
    func select(category: Category) {
        selectedCategory = category
    }
}
