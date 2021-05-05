//
//  MockTodoController.swift
//  Todo
//
//  Created by Ryan Bitner on 5/4/21.
//

import Foundation



class ToDoController {
    
    var todos: [Todo] = []
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static let propertyListEncoder = PropertyListEncoder()
    static let propertyListDecoder = PropertyListDecoder()
    
    init() {
        if let retreivedTodosData = try? Data(contentsOf: ToDoController.archiveURL), let decodedTodos = try? ToDoController.propertyListDecoder.decode([Todo].self, from: retreivedTodosData) {
            todos = decodedTodos
        }
    }
    
    func updateTodo(todo: Todo) {
        
        if let changedIndex = todos.firstIndex(where: {$0.id == todo.id } ) {
            todos[changedIndex] = todo
        } else {
            todos.append(todo)
        }
        
        let encodedTodos = try? ToDoController.propertyListEncoder.encode(todos)
        try? encodedTodos?.write(to: ToDoController.archiveURL, options: .noFileProtection)

    }
}

let todoController = ToDoController()
