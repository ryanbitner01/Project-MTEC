//
//  Habbits.swift
//  Habbits
//
//  Created by Ryan Bitner on 8/17/21.
//

import Foundation

class Habbits: ObservableObject {
    @Published var activities: [Activity] = []
    
    init(_ activities: [Activity] = []) {
        self.activities = activities
    }
}
