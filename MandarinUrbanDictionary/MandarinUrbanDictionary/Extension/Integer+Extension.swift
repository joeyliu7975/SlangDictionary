//
//  Integer+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/25/20.
//

import Foundation

extension Int {
    var rankString: String {
        switch self {
        case 0:
            return String(describing: "最佳解釋")
        default:
            return String(describing: self + 1)
        }
    }
}
