//
//  FavoriteViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import Foundation

class FavoriteViewModel {
    
    var mockData: [Category] = .init()
    
    var selectedWord = [Category]() {
        didSet {
            deleteButtonEnable?(!selectedWord.isEmpty)
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            toggleEditMode?(isEditing)
        }
    }
    
    var fetchData: (() -> Void)?
    
    var toggleEditMode: ((Bool) -> Void)?
    
    var removeData: ((Int) -> Void)?
    
    var removeAll: (() -> Void)?
    
    var deleteButtonEnable: ((Bool) -> Void)?
    
    func makeMockData() {
        mockData = Category.allCases
        fetchData?()
    }
    
    func select(at index: IndexPath) {
        
        if selectedWord.contains(mockData[index.row]) {
            guard let index = selectedWord.firstIndex(of: mockData[index.row]) else { return }
            
            selectedWord.remove(at: index)
        } else {
            selectedWord.append(mockData[index.row])
        }
    }
    
    func tapDelete() {
        selectedWord.forEach {
            if let index = mockData.firstIndex(of: $0) {
                removeData?(index)
            }
            
        }
        
        selectedWord.removeAll()
    }
    
    func tapDeleteAll() {
        
        mockData.removeAll()
        
        selectedWord.removeAll()
        
        removeAll?()
    }
    
}
