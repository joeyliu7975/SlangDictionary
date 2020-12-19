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
    
    var keyword: String = ""
        
    private let networkManager: FirebaseManager
    
    init(networkManager: FirebaseManager = .init()) {
        self.networkManager = networkManager
    }
    
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
        
        keyword.removeAll()
        
        result.value.removeAll()
        
    }
}

extension SearchViewModel {
    
    func showResult<T: Codable> (keyword: String, result: [T]) -> SearchResult {
        if keyword.isEmpty {
            
            return .noKeyword
            
        } else if result.isEmpty {
            
            return .noMatchFound
            
        } else {
            
            return .hasResult
            
        }
    }

}

extension SearchViewModel {
    
    enum SearchResult {
        case noKeyword, noMatchFound, hasResult
    }
}

private extension SearchViewModel {
    
    func filter(_ words: [Word], with keyword: String) {
        
        var filtered = [Word]()
        
        filtered = words.filter { $0.title.fuzzyMatch(keyword) }
            
        result.value = filtered
    }
    
}
