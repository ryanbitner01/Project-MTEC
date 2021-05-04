//
//  ToDoTableViewController.swift
//  Todo
//
//  Created by Ryan Bitner on 5/4/21.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    let todoController = MockToDoController()
    var todos: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todos = todoController.fetchTodos()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        
        cell.delegate = self
        cell.setTodo(todo: todo)
        
        return cell
    }

}

extension ToDoTableViewController: TodoCellDelegate {
    func completedButtonTapped(todo: Todo) {
        var changedTodo = todo
        changedTodo.completed.toggle()
        todoController.updateTodo(todo: changedTodo)
        todos = todoController.fetchTodos()
        tableView.reloadData()
    }
    
}
