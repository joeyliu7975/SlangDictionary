//
//  FavoriteViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/9/20.
//

import Foundation

class FavoriteViewModel {
    
    var title: String
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            
            switch title == "Favorites" {
            case true:
                user.favorites.forEach {
                    networkManager.retrieveWord(id: $0) { (result: Result<Word, NetworkError>) in
                        switch result {
                        case .success(let word):
                            self.favoriteViewModels.value.append(word)
                        case .failure(.noData(let error)):
                            print(error.localizedDescription)
                        case .failure(.decodeError):
                            print("Decode Error!")
                        }
                    }
                }
            case false:
                user.recents.forEach {
                    networkManager.retrieveWord(id: $0) { (result: Result<Word, NetworkError>) in
                        switch result {
                        case .success(let word):
                            self.favoriteViewModels.value.append(word)
                        case .failure(.noData(let error)):
                            print(error.localizedDescription)
                        case .failure(.decodeError):
                            print("Decode Error!")
                        }
                    }
                }
            }
            
//            user.favorites.forEach {
//                networkManager.retrieveWord(id: $0) { (result: Result<Word, NetworkError>) in
//                    switch result {
//                    case .success(let word):
//                        self.favoriteViewModels.value.append(word)
//                    case .failure(.noData(let error)):
//                        print(error.localizedDescription)
//                    case .failure(.decodeError):
//                        print("Decode Error!")
//                    }
//                }
//            }
        }
    }
    
    let networkManager: FirebaseManager = .init()
    
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
    
    init(title: String) {
        self.title = title
    }
    
    // Firebase 操作
    
    func getUserFavoriteWordsList() {
        
        guard let uid = UserDefaults.standard.value(forKey: "uid") as? String else { return }
 
        networkManager.retrieveUser(userID: uid) { (result: Result<User, NetworkError>) in
            switch result {
            case .success(let user):
                
                self.user = user
                
            case .failure(.noData(let error)):
                print(error.localizedDescription)
            case .failure(.decodeError):
                print("Decode Error!")
            }
        }

    }
    
    // MARK Local 操作
    
    func select(at index: IndexPath) {
        
       let isWordSelected = selectedWord.contains(favoriteViewModels.value[index.row])
        
        switch isWordSelected {
        case true:
           
            guard let index = selectedWord.firstIndex(of: favoriteViewModels.value[index.row]) else { return }
            
            selectedWord.remove(at: index)
            
        case false:
            
            selectedWord.append(favoriteViewModels.value[index.row])
            
        }
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
