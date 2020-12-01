//
//  HomePageViewModel.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/26/20.
//

import Foundation

enum Carousel: CaseIterable {
    case mostViewedWord
    
    case newestWord
}

class HomePageViewModel {
    
    var cellCount: Int {
        let carouselList = Carousel.allCases
        
        return carouselList.count
    }
    
    var collectionViewContents = ["whats_new", "top5"]
        
    var updateHot5: ( () -> Void )?
    
     func renderCell(at carousel: Carousel) -> IndexPath {
        switch carousel {
        case .mostViewedWord:
            return IndexPath(row: 0, section: 0)
        case .newestWord:
            return IndexPath(row: 1, section: 0)
        }
    }
}
