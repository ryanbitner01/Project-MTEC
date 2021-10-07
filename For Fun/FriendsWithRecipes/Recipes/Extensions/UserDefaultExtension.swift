//
//  UserDefaultExtension.swift
//  Recipes
//
//  Created by Ryan Bitner on 10/7/21.
//

import Foundation

extension UserDefaults {
    var userPassword: String? {
        get {
            self.string(forKey: #function)
        }
        set {
            self.setValue(newValue, forKey: #function)
        }
    }
    
    var userEmail: String? {
        get {
            self.string(forKey: #function)
        }
        set {
            self.setValue(newValue, forKey: #function)
        }
    }
    
    var rememberMe: Bool? {
        get {
            self.bool(forKey: #function)
        }
        set {
            self.setValue(newValue, forKey: #function)
        }
    }
    
    var staySignedIn: Bool? {
        get {
            self.bool(forKey: #function)
        }
        set {
            self.setValue(newValue, forKey: #function)
        }
    }
}
