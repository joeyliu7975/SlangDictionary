//
//  DefinitionViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/30/20.
//

import Foundation

class DefinitionViewModel {
    
    let networkManager: FirebaseManager = .init()
    
    var wordIdentifier: String
    
    var updateData: (() -> Void)?
    
    var isLike: Bool = false {
        didSet {
            updateData?()
        }
    }
    
    init(id: String) {
        wordIdentifier = id
    }
        
    var definitionViewModels = Box([Definition]())
    
    func listen() {
        networkManager.listen(.definition(self.wordIdentifier)) { (result: Result<[Definition], Error>) in
            switch result {
            case .success(let definitions):
                
                self.definitionViewModels.value = definitions
                
            case .failure(let error):
                
                print("Fatal Error with: \(error.localizedDescription)")
                
            }
        }
    }
    
//    {
//        didSet {
//            updateData?()
//        }
//    }
    
//    func makeMockData(amount: Int) {
//
//        let firstLine = "The Dodo is an American media brand focused on telling animals' stories and animal rights issues."
//
//        let secondLine = "The Dodo was launched in January 2014 by Izzie Lerer, the daughter of media executive Kenneth Lerer."
//
//        let mockData:[Definition] = [Definition](
//            repeating: Definition(
//                content: firstLine + secondLine,
//                like: [
//                    "1",
//                    "2",
//                    "1",
//                    "1",
//                    "1",
//                    "1",
//                ],
//                dislike: [],
//                report: "Nothing",
//                identifier: "123456789",
//                time: FirebaseTime(),
//                idForWord: "35678"
//            ),
//            count: 3
//        )
//
//        definitions = mockData
//    }
    
    func convertRank(with rank: Int) -> String {
        
        var rankString: String
        
        switch rank {
        
        case 0:
            
            rankString = "Top Definition"
            
        default:
            
            rankString = String(describing: rank + 1)
            
        }
        
        return rankString
    }
}
