//
//  NotificationCenterManager.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 12/21/20.
//

import UIKit

protocol NotificationRegister {
    func registerLocal()
}

protocol NotificationSchedule {
    func scheduleLocal()
}

class NotificationCenterManager: NotificationRegister, NotificationSchedule {
    
    func registerLocal() {
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
    
    func scheduleLocal() {
          
        let center = UNUserNotificationCenter.current()
        
//        center.removeAllPendingNotificationRequests()
        
        center.getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        let content = UNMutableNotificationContent()
        
        content.title = "每日幹話挑戰"
        
        content.body = "你今天說幹話了嗎?"
        
        content.sound = .default
        
        content.categoryIdentifier = "alarm"
        
        content.userInfo = ["customData": "fizzbuzz"]
        
//        var dateComponents = DateComponents()
//
//        dateComponents.hour = 14
//
//        dateComponents.minute = 49
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
}
