//
//  ToDo.swift
//  Todo
//
//  Created by Ryan Bitner on 5/4/21.
//

import Foundation

struct Todo: Codable {
    let id: UUID
    let name: String
    var completed: Bool
    
    init(id: UUID = UUID(), name: String, completed: Bool) {
        self.id = id
        self.name = name
        self.completed  = completed
    }

}
