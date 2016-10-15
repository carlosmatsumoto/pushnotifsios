//
//  AppDelegate.swift
//  pushnotifs
//
//  Created by Kenji Matsumoto on 10/11/16.
//  Copyright © 2016 Carlos Kenji Matsumoto. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            // do something with granted and error
        }
        
        
        
        application.registerForRemoteNotifications()
        
        
        FIRApp.configure()
        
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(self.tokenRefreshNotification),
            name: NSNotification.Name.firInstanceIDTokenRefresh,
            object: nil)
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
        print("Desconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        connectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
        

    func connectToFCM(){
        FIRMessaging.messaging().connect { (error) in
            if (error != nil){
                print("Unable to connect \(error)")
            } else {
                print("Connected to FCM")
            }
        }
    }
    
    func tokenRefreshNotification(notification: NSNotification){
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        connectToFCM()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
    }
    
    
    @objc(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:) func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        print("User Info: \(response.notification.request.content.userInfo)")
        print("Volume: \(response.notification.request.content.userInfo["volume"])")
        print("Volume: \(response.notification.request.content.userInfo["contents"])")
        print("text: \(response.notification.request.content.userInfo["aps"])")
        
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        print("User Info: \(notification.request.content.userInfo)")
    }
    
}



