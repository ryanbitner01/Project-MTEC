//
//  ViewController.swift
//  Bitner Condo
//
//  Created by Ryan Bitner on 4/14/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var invalidLoginLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        invalidLoginLabel.isHidden = true
    }

    @IBAction func loginPressed(_ sender: Any) {
        guard let user = userTextField.text, let password = passwordTextField.text else {return}
        if User.checkPassword(username: user, password: password) {
            print("Success")
            guard let currentUser = User.loginUser(username: user) else {return}
            self.user = currentUser
            if currentUser.isAdmin {
                performSegue(withIdentifier: "loginAdmin", sender: self)
            } else {
                performSegue(withIdentifier: "loginUser", sender: self)
            }
        }
        else {
            invalidLoginLabel.isHidden = false
        }
    }
}

