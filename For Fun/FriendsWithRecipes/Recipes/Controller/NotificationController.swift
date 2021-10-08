//
//  NotificationController.swift
//  Recipes
//
//  Created by Ryan Bitner on 10/7/21.
//

import Foundation
import UserNotifications
import FirebaseMessaging
import Firebase

class NotificationController {
    static let shared = NotificationController()
    
    let center = UNUserNotificationCenter.current()
    
    private init() {
        
    }
    
    func getNotificationSettings() {
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {return}
            
            if settings.alertSetting == .enabled {
                
            } else {
                
            }
        }
    }
    
    func updateToken() {
        if let token = Messaging.messaging().fcmToken, let profileTokens = UserControllerAuth.shared.profile?.noticationTokens {
            if !profileTokens.contains(where: {$0 == token}) {
                guard let path = getUserPath(), let user = UserControllerAuth.shared.user else {return}
                path.document(user.id).setData([
                    "notificationToken": FieldValue.arrayUnion([token])
                ], merge: true)
            }
        }
        
    }
    
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
//        let paramString: [String : Any] = ["to" : token,
//                                           "notification" : ["title" : title, "body" : body],
//                                           "apns": ["payload": [
//                                            "aps": [
//                                                "badge": 1
//                                            ]
//                                           ]]
//        ]
        let paramString: [String: Any] = [
            "to": token,
            "notification": [
                "title": title,
                "body": body,
                "badge": "1"
            ]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAACL4gfzs:APA91bFgMi09Qe_04edFilgPxcW-PpiIyojkjZyfZ9yIPADlBbjuwEXbfQ1UpQl8iKhxQupC694QecQKVH7f04j25RVGz2yHXd31eH9Zj6Rk9X7UKCWKKkKVE1-uaMreDla6M5jfXKiI", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
}
