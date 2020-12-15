//
//  FavoriteViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import Foundation

class FavoriteViewModel {
    
    var favoriteViewModels = Box([Word]())
    
    var selectedWord = [Word]() {
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
    
//    func makeMockData() {
//
//        favoriteViewModels = Category.allCases
//
//        fetchData?()
//    }
    
    func select(at index: IndexPath) {
        
       let isWordSelected = selectedWord.contains(favoriteViewModels.value[index.row])
        
        switch isWordSelected {
        case true:
           
            guard let index = selectedWord.firstIndex(of: favoriteViewModels.value[index.row]) else { return }
            
            selectedWord.remove(at: index)
            
        case false:
            
            selectedWord.append(favoriteViewModels.value[index.row])
            
        }
        
//        if selectedWord.contains(favoriteViewModels.value[index.row]) {
//            guard let index = selectedWord.firstIndex(of: favoriteViewModels.value[index.row]) else { return }
//
//            selectedWord.remove(at: index)
//        } else {
//            selectedWord.append(favoriteViewModels[index.row])
//        }
    }
    
    func tapDelete() {
        selectedWord.forEach {
            if let index = favoriteViewModels.value.firstIndex(of: $0) {
                removeData?(index)
            }
            
        }
        
        selectedWord.removeAll()
    }
    
    func tapDeleteAll() {
        
        favoriteViewModels.value.removeAll()
        
        selectedWord.removeAll()
        
        removeAll?()
    }
    
    func removeSelections() {
        
        selectedWord.removeAll()
        
    }
    
}
