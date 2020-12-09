//
//  FavoriteViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import Foundation

class FavoriteViewModel {
    
    var mockData: [Category] = .init()
    
    var selectedWord = [Category]()
    
    var fetchData: (() -> Void)?
    
    var removeData: ((Int) -> Void)?
    
    func makeMockData() {
        mockData = Category.allCases
        fetchData?()
    }
    
    func select(at index: IndexPath) {
        selectedWord.append(mockData[index.row])
    }
    
    func tapDelete() {
        selectedWord.forEach {
            if let index = mockData.firstIndex(of: $0) {
                removeData?(index)
            }
            
        }
        
        selectedWord.removeAll()
    }
    
}
