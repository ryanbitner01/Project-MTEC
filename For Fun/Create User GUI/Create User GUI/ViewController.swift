//
//  ViewController.swift
//  Create User GUI
//
//  Created by Ryan Bitner on 2/3/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    var currentPage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginPage()
    }
    
    struct Login {
        var username: String
        var password: String
        static var isLoggedIn = false
        static var currentUser = ""
        static var users: [String] = []
        static var passwords = [String:String]()
        
        init(user: String, password: String) {
            username = user
            self.password = password
            Login.users.append(username)
            Login.passwords[username] = password
        }
        
        static func login(user: String, password: String) {
            if users.contains(user) {
                if password == passwords[user]{
                    if isLoggedIn == false {
                        currentUser = user
                        print("Logging in \(user).....")
                        isLoggedIn = true
                    } else {
                        print("Already Logged In")
                    }
                } else {
                    print("Invalid Username or Password")
                }
            } else {
                print("Invalid Username or Password")
            }
        }
    }
    
    func user(username: String, password: String) {
        let forbiddenCharPassword = ["&", "(", ")", "%"]
        let fobiddenCharUser = ["!", "@", "#", "$", "%", "&" ,"  *", "(", ")"]
        for char in username {
            if fobiddenCharUser.contains(String(char)) {
                print("No")
            } else {
                for char in password {
                    if forbiddenCharPassword.contains(String(char)) {
                        print("No")
                    } else {
                        _ = Login(user: username, password: password)
                    }
                }
            }
        }
    }
    
    func login(user: String, password: String) {
        if Login.users.contains(user) {
            if password == Login.passwords[user]{
                if Login.isLoggedIn == false {
                    Login.currentUser = user
                    mainMenu()
                    Login.isLoggedIn = true
                }
            } else {
                warningLabel.isHidden = false
            }
        } else {
            warningLabel.isHidden = false
        }
    }
    
    func loginPage() {
        warningLabel.isHidden = true
        userLabel.isHidden = false
        passwordTextField.isHidden = false
        userTextField.isHidden = false
        passwordLabel.isHidden = false
        myButton.isHidden = false
        createUserButton.isHidden = false
        currentPage = "Login"
        createUserButton.setTitle("Create User", for: .normal)
        myButton.setTitle("Login", for: .normal)
        userLabel.text = "Username"
        passwordLabel.text = "Password"
        userTextField.text = ""
        passwordTextField.text = ""
    }
    
    func createUserPage() {
        warningLabel.isHidden = true
        userLabel.isHidden = false
        passwordTextField.isHidden = false
        userTextField.isHidden = false
        passwordLabel.isHidden = false
        myButton.isHidden = false
        createUserButton.isHidden = false
        userLabel.text = "New Username"
        passwordLabel.text = "New Password"
        myButton.setTitle("Done", for: .normal)
        currentPage = "CreateUser"
        createUserButton.setTitle("Cancel", for: .normal)
        userTextField.text = ""
        passwordTextField.text = ""
    }
    
    func mainMenu() {
        warningLabel.isHidden = true
        userLabel.isHidden = true
        passwordTextField.isHidden = true
        userTextField.isHidden = true
        passwordLabel.isHidden = true
        myButton.isHidden = false
        createUserButton.isHidden = true
        myButton.setTitle("Logout", for: .normal)
        currentPage = "Main"
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        switch currentPage {
        case "CreateUser":
            if userTextField.text != "" && passwordTextField.text != "" {
                _ = Login(user: userTextField.text!, password: passwordTextField.text!)
                if Login.users.contains(userTextField.text!) {
                    loginPage()
                }
            } else {
                warningLabel.isHidden = false
            }
          
        case "Main":
            loginPage()
            Login.currentUser = ""
            Login.isLoggedIn = false
        case "Login":
            login(user: userTextField.text!, password: passwordTextField.text!)
        default:
            print("Not Found")
        }
        
        
    }
    
    @IBAction func createUserButtonPressed(_ sender: Any) {
        switch currentPage {
        case "CreateUser":
            loginPage()
        default:
            createUserPage()
        }
    }
    
    
}

