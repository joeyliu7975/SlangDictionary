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
    
    var keyword: String?
        
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
        
        networkManager.retrieveData(.word(orderBy: .views)) { [weak self] (result: Result<[Word], Error>) in
            
            switch result {
            
            case .success(let words):
                
                self?.keyword = keyword
                
                self?.filter(words, with: keyword)
                
            case .failure(let error):
                
                print("Fatal Error with: \(error.localizedDescription)")
            }
            
        }
    }
    
    func updateViewsOfWord(at index: Int) {
        
        let id = result.value[index].identifier
        
        var views = result.value[index].views
        
        views += 1
        
        self.networkManager.updateViews(id: id, views: views) {
            print("successful update!")
        }
        
    }
    
    func clearSearchBar() {
        
        result.value.removeAll()
        
        keyword = nil
        
    }
    
    func select(category: Category) {
        selectedCategory = category
    }
}

private extension SearchViewModel {
    
    func filter(_ data: [Word], with keyword: String) {
        
        var filtered = [Word]()
            
        keyword.forEach { (character) in
            
            filtered = data.filter { (word) -> Bool in
                return word.title.contains(character)
            }
            
        }
        
        result.value = filtered
        
    }
    
}
