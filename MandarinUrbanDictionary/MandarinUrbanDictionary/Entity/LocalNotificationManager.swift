//
//  NotificationCenterManager.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/21/20.
//

import UIKit

enum NotificationTime {
    case morning
    case evening
}

class LocalNotificationManager {
    
    static func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            switch granted {
            case true:
                print("Yaay")
            case false:
                print("Duh'Oh")
            }
        }
    }
    
    static func scheduleLocal(title: LocalNotificationManager.CustomNotification, body: String, time: NotificationTime, identifier: CustomNotification) {
          
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers: [identifier.identifier])
                
        center.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = title.rawValue
        
        content.body = body
                
        content.categoryIdentifier = "alarm"
        
        content.userInfo = ["customData": "fizzbuzz"]
        
        content.badge =  UIApplication.shared.applicationIconBadgeNumber as NSNumber
        
        var dateComponents = DateComponents()
        
        switch time {
        case .morning:
            dateComponents.hour = 08

            dateComponents.minute = 00
        case .evening:
            dateComponents.hour = 21

            dateComponents.minute = 00
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier.identifier, content: content, trigger: trigger)
        
        center.add(request)
    }
    
}

extension LocalNotificationManager {
    enum CustomNotification: String {
        case news = "一起學習最新幹話"
        case favorite = "收藏經典回顧"
        case explore = "說幹話，長知識"
        
        var identifier: String {
            switch self {
            case .news:
                return "news"
            case .favorite:
                return "favorite"
            case .explore:
                return "explore"
            }
        }
    }
    
    
}
