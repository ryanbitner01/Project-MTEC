//
//  CreateUserViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/5/21.
//

import UIKit

class CreateUserViewController: UIViewController {

    @IBOutlet weak var displayNameLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var otherPasswordTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    //var usernameIsValid = false
    var passwordIsValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSaveButtonState()
        alertLabel.isHidden = true
    }

    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        saveUser()
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if sender == emailTextField {
            //verifyUsername()
        } else if sender == passwordTextField || sender  == otherPasswordTextField {
            verifyPassword()
        }
        updateSaveButtonState()
    }
    
    @IBAction func donePressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
//    func verifyUsername() {
//        guard UserController.shared.checkUsernameLength(username: usernameTextField.text!) else {
//            showAlert(err: .usernameLength)
//            usernameIsValid = false
//            return
//        }
//        hideAlert()
//        usernameIsValid = true
//    }
    
    func verifyPassword() {
        guard UserControllerAuth.shared.checkPasswordLength(password: passwordTextField.text!) else {
            passwordIsValid = false
            showAlert(err: .passwordLength )
            return
        }
        guard UserControllerAuth.shared.checkSamePassword(p1: passwordTextField.text!, p2: otherPasswordTextField.text!) else {
            passwordIsValid = false
            showAlert(err: .passwordMatch)
            return
        }
        hideAlert()
        passwordIsValid = true
    }
    
    func showAlert(err: UserControllerError) {
        alertLabel.text = err.localizedDescription
        alertLabel.isHidden = false
    }
    
    func hideAlert() {
        alertLabel.isHidden = true
    }
    
    func updateSaveButtonState() {
        guard let username = emailTextField.text, let password = passwordTextField.text, let p2 = otherPasswordTextField.text, let email = emailTextField.text else {return}
        let meetsRequirements = !(username.isEmpty || password.isEmpty || email.isEmpty || email.isEmpty || p2.isEmpty) && passwordIsValid
        saveButton.isEnabled = meetsRequirements
    }
    
    func saveUser() {
        UserControllerAuth.shared.createUser(email: emailTextField.text!, password: passwordTextField.text!, displayName: displayNameLabel.text!) {err in
            if let err = err {
                DispatchQueue.main.async {
                    self.showAlert(err: err)
                }
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
}

extension CreateUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            otherPasswordTextField.becomeFirstResponder()
        case otherPasswordTextField:
            emailTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

