//
//  RankViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/12/20.
//

import UIKit

class RankViewModel {
    
    let rankList: [RankColor] = [
        .top,
        .second,
        .third,
        .fourth,
        .fifth
    ]
    
    var wordViewModels = Box([Word]())
    
    var top5WordList: [String] = .init() {
        didSet {
            updateData?()
        }
    }
    
    var updateData: (() -> Void)?
    
    let networkManager: FirebaseManager = .init()
    
    func fetchData(sortedBy value: FirebaseManager.SortedBy) {
        
        networkManager.retrieveData(.word(orderBy: value)) { (result: Result<[Word], Error>) in
            
            switch result {
            case .success(let words):
                
                self.wordViewModels.value = words
                
                let number = 5
                
                let top5Words = words[0 ..< number]
                
                self.top5WordList = top5Words.map{ $0.title }
                
            case .failure:
                break
            }
        }
    }
    
    func retrieveAndfilterData(by category: String) {
        networkManager.retrieveData(.word(orderBy: .views), with: category) { (result: Result<[Word], Error>) in
            
            switch result {
            case .success(let words):
                
                self.wordViewModels.value = words
                
                let number = 5
                
                let top5Words = words[0 ..< number]
                
                self.top5WordList = top5Words.map{ $0.title }
                
            case .failure:
                break
            }
        }
    }
}

extension RankViewModel {
    enum RankColor: String {
        case top = "#6DC0F8"
        case second = "#8ACCF9"
        case third = "#98D2FA"
        case fourth = "#A7D9FB"
        case fifth = "#B5E0FB"
        
        func makeColor() -> UIColor {
            return UIColor.hexStringToUIColor(hex: self.rawValue)
        }
    }
}
