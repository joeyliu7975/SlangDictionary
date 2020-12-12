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
    
    var nameList: [String] = .init()
    
    let networkManager: FirebaseManager = .init()
    
    func fetchData() {
        
        networkManager.retrieveData(.word) { (result: Result<[Word], Error>) in
            print(result)
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
