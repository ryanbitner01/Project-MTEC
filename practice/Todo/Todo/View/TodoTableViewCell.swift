//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by Ryan Bitner on 5/4/21.
//

import UIKit

protocol TodoCellDelegate {
    func completedButtonTapped(todo: Todo)
}

class TodoTableViewCell: UITableViewCell {
    
    var todo: Todo?
    var delegate: TodoCellDelegate?
    
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func completedButtonTapped(_ sender: Any) {
        guard let todo = todo else {return}
        
        delegate?.completedButtonTapped(todo: todo)
    }
    
    func setTodo(todo: Todo) {
        self.todo = todo
        nameLabel.text = todo.name
        completedButton.setImage(todo.completed ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
    }
    
}
