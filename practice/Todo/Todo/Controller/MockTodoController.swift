//
//  MockTodoController.swift
//  Todo
//
//  Created by Ryan Bitner on 5/4/21.
//

import Foundation

class MockToDoController {
    var todos: [Todo] = [Todo(name: "Buy Milk", completed: true),
                         Todo(name: "Paint the house", completed: false)]
    
    func fetchTodos() -> [Todo] {
        return todos
    }
    
    func updateTodo(todo: Todo) {
        guard let changedIndex = todos.firstIndex (where: {$0.id == todo.id } ) else { return todos.append(todo) }
        todos[changedIndex] = todo
    }
}
