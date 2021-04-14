//
//  EditUserTableViewController.swift
//  Bitner Condo
//
//  Created by Ryan Bitner on 4/14/21.
//

import UIKit

class EditUserTableViewController: UITableViewController {
    
    var user: User?
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = user {
            self.navigationItem.title = user.familyName
            userTextField.text = user.username
            passwordTextField.text = user.password
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let username = userTextField.text, let password = passwordTextField.text, var user = self.user else {return}
        user.username = username
        user.password = password
        self.user = user
    }

}
