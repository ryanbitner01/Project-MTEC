//
//  NotificationController.swift
//  Recipes
//
//  Created by Ryan Bitner on 10/7/21.
//

import Foundation
import UserNotifications

class NotificationController {
    static let shared = NotificationCenter()
    
    let center = UNUserNotificationCenter.current()
    
    private init() {
        
    }
    
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, err in
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }
    
    func getNotificationSettings() {
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {return}
            
            if settings.alertSetting == .enabled {
                
            } else {
                
            }
        }
    }
}
