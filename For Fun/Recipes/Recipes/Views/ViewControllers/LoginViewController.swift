//
//  LoginViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 4/23/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    //var canLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alertLabel.isHidden = true
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
        
        
        //        if UserController.shared.loginUser(username: username, password: password) {
        //            performSegue(withIdentifier: "LoginUser", sender: self)
        //        } else {
        //            showAlert(message: "Invalid Username/Password")
        //        }
        
        
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
    
    //    func initUsers() {
    //        UserController.shared.getUsers { result in
    //            switch result {
    //            case .success(let users):
    //                UserController.shared.users = users
    //            case .failure(let err):
    //                print(err.localizedDescription)
    //            }
    //        }
    //    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
