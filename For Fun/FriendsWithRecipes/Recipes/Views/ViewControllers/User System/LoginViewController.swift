//
//  LoginViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 4/23/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    //var canLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        self.hideKeyboardTappedAround()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alertLabel.isHidden = true
        getRememberedEmail()
    }
    
    func getRememberedEmail() {
        if UserControllerAuth.shared.getRememberMe() {
            rememberMeButton.isSelected = true
            usernameTextField.text = UserControllerAuth.shared.getRememberedEmail()
        }
    }
    func showAlert(message: String) {
        alertLabel.isHidden = false
        alertLabel.text = message
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = usernameTextField.text, let password = passwordTextField.text else {return}
        UserControllerAuth.shared.loginUser(email: email, password: password) { err in
            if let err = err {
                DispatchQueue.main.async {
                    self.showAlert(message: err.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoginUser", sender: self)
                    print("LOGIN SUCCESSFUL")
                }
            }
        }
    }
    
    @IBAction func logoutUnwind(_ unwindSegue: UIStoryboardSegue) {
        UserControllerAuth.shared.logoutUser()
        usernameTextField.text = ""
        passwordTextField.text = ""
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func donePressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func rememberMeButton(_ sender: UIButton) {
        rememberMeButton.isSelected.toggle()
        
    }
    
    func rememberEmail() {
        if rememberMeButton.state == .selected {
            UserControllerAuth.shared.rememberEmail(email: usernameTextField.text!, rememberMe: true)
            print("SAVE")
        } else if rememberMeButton.state == .normal {
            UserControllerAuth.shared.rememberEmail(email: "", rememberMe: false)
            print("CLEAR")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        rememberEmail()
    }
    
}
