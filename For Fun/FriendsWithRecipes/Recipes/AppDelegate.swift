//
//  AppDelegate.swift
//  Recipes
//
//  Created by Ryan Bitner on 3/10/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
<<<<<<< HEAD
import FirebaseMessaging
import UserNotifications
import UserMessagingPlatform
import GoogleMobileAds

=======
>>>>>>> parent of 54122dd (Adds)

let db = Firestore.firestore()
let storage = Storage.storage()
let auth = Auth.auth()

@main
<<<<<<< HEAD
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, err in
            guard success else {return}
            
            
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, err in
            guard let token = token else {return}
            print(token)
        }
    }
    
    //    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    //        print(remoteMessage.appData)
    //    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // reset badge count
        application.applicationIconBadgeNumber = 0
    }
    
    // Initialize the Google Mobile Ads SDK.
       GADMobileAds.sharedInstance().start(completionHandler: nil)    // MARK: UISceneSession Lifecycle
    
=======
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

>>>>>>> parent of 54122dd (Adds)
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


}

