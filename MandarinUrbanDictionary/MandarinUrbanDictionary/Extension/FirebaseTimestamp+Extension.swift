//
//  FirebaseTimestamp+Extension.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/12/20.
//

import Foundation
import Firebase

extension Timestamp {
    
    func timeStampToStringDetail() -> String {
        let timeSta = self.dateValue()
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日"
        return dfmatter.string(from: timeSta)
      }
}
