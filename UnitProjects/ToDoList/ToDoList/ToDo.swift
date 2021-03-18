//
//  ToDo.swift
//  ToDoList
//
//  Created by Ryan Bitner on 3/16/21.
//

import Foundation

struct ToDo {
    let id = UUID()
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func loadToDos() -> [ToDo]? {
        return nil
    }
}
