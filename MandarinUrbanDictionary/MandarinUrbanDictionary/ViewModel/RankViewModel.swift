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
                
                self.top5WordList = top5Words.map { $0.title }
                
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
    func getCategory(_ selectedCategory: Category) {
        var category: String = ""
        
        switch selectedCategory {
        case .all:
            category = ""
        case .engineer:
            category = "工程師"
        case .job:
            category = "職場"
        case .school:
            category = "校園"
        case .pickUpLine:
            category = "撩妹"
        case .restaurant:
            category = "餐飲"
        case .game:
            category = "遊戲"
        case .gym:
            category = "健身"
        case .relationship:
            category = "感情"
        }
        
        switch category == "" {
        case true:
            fetchData(sortedBy: .views)
        case false:
            retrieveAndfilterData(by: category)
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
