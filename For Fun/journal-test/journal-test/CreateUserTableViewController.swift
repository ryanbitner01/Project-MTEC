//
//  CreateUserTableViewController.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/30/21.
//

import UIKit

class CreateUserTableViewController: UITableViewController {
    
    let controller = DataController()
    
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var otherPasswordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var alertCell: UITableViewCell!
    @IBOutlet weak var alertText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertCell.isHidden = true
    }
    
    func showAlert(message: String) {
        alertCell.isHidden = false
        alertText.text = message
    }
    
    func updateCreatButtonState() {
        guard let user = userTextField.text, let password = passwordTF.text, let otherPassword = otherPasswordTF.text, let email = emailTF.text else {return}
        createButton.isEnabled = !(user.isEmpty && password.isEmpty && otherPassword.isEmpty && email.isEmpty)
        
    }
    
    @IBAction func createButtonTapped(_ sender: UIBarButtonItem) {
        guard let userText = userTextField.text, let passwordText = passwordTF.text, let otherPasswordText = otherPasswordTF.text, let emailText = emailTF.text else {return}
        guard User.checkUserDuplicate(userText) else {
            showAlert(message: "Another user exists with this username.")
            return
        }
        guard User.checkPasswordLength(passwordText) else {
            showAlert(message: "Password must be at least 8 characters")
            return
        }
        guard User.checkPasswordMatch(p1: passwordText, p2: otherPasswordText) else {
            showAlert(message: "Passwords don't match")
            return
        }
        let user = User(user: userText, password: passwordText, email: emailText)
        User.users.append(user)
        controller.addUser(user)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func textFieldEdited(_ sender: UITextField) {
        updateCreatButtonState()
    }
    
}
