//
//  LoginUserViewController.swift
//  journal-test
//
//  Created by Ryan Bitner on 4/30/21.
//

import UIKit

class LoginUserViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    var user: User?
    
    let controller = DataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.fetchUsers { result in
            switch result {
            case .success(let users):
                User.users = users
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func showAlert(message: String) {
        alertLabel.isHidden = false
        alertLabel.text = message
    }

    @IBSegueAction func loginButtonPressed(_ coder: NSCoder) -> JournalTableViewController? {
        guard let userText = userTextField.text, let passwordText = passwordTextField.text, let user = User.checkValidUser(username: userText, password: passwordText) else {
            showAlert(message: "Invalid Username or Password")
            return nil
        }
        let journalTableViewController = JournalTableViewController(coder: coder)
        journalTableViewController?.user = user
        return journalTableViewController
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let userText = userTextField.text, let passwordText = passwordTextField.text, let user = User.checkValidUser(username: userText, password: passwordText) else {
            showAlert(message: "Invalid Username or Password")
            return
        }
        self.user = user
        performSegue(withIdentifier: "loginUser", sender: self)
    }
    
    @IBSegueAction func loginUser(_ coder: NSCoder) -> JournalTableViewController? {
        guard let user = user else { return nil }
        let journalTableViewController = JournalTableViewController(coder: coder)
        journalTableViewController?.user = user
        return journalTableViewController
    }
    
}
