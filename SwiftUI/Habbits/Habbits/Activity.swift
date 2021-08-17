//
//  File.swift
//  Habbits
//
//  Created by Ryan Bitner on 8/17/21.
//

import Foundation

struct Activity: Identifiable {
    let id: UUID
    let name: String
    let description: String
    var frequency: Int = 0
}
