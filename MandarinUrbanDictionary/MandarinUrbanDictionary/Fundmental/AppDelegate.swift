//
//  AppDelegate.swift
//  MandarinUrbanDictionary
//
//  Created by Joey Liu on 11/27/20.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    let notificationManager: LocalNotificationManager = .init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        
        IQKeyboardManager.shared.toolbarTintColor = .homepageDarkBlue
        
        disableIQKeyboardOnParticularVC()
                
        setupNotification(on: application)
        
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            pushNotification()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        pushNotification()
        
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.restrictRotation
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate {
    
    func setupNotification(on application: UIApplication) {
        let center = UNUserNotificationCenter.current()

        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .badge]) { (granted, error) in
            switch granted {
            case true:
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            case false:
                print("Oh no!")
            }
        }
    }

    func pushNotification() {
        LocalNotificationManager.scheduleLocal(title: .explore, body: "探索最新幹話，增加尬聊趣味", time: .morning)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
}

extension AppDelegate {
    private func disableIQKeyboardOnParticularVC() {
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(NewDefinitionViewController.self)
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(NewDefinitionViewController.self)
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ReportViewController.self)
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(ReportViewController.self)
    }
}
