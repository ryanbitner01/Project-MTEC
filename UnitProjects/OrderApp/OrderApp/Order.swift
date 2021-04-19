//
//  Order.swift
//  OrderApp
//
//  Created by Ryan Bitner on 4/19/21.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
