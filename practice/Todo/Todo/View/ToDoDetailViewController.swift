//
//  ToDoDetailViewController.swift
//  Todo
//
//  Created by Ryan Bitner on 5/4/21.
//

import UIKit

class ToDoDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        let todo = Todo(name: name, completed: false)
        todoController.updateTodo(todo: todo)
        dismiss(animated: true, completion: nil)
        
    }

}
