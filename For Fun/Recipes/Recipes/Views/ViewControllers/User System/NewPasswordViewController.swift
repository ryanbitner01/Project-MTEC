//
//  NewPasswordViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/23/21.
//

import UIKit

class NewPasswordViewController: UIViewController {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var otherPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var passwordIsValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardTappedAround()
        setupTextFields()
        updateSaveButtonState()
        hideAlert()
        self.hideKeyboardTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func setupTextFields() {
        passwordTextField.delegate = self
        otherPasswordTextField.delegate = self
    }
    
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
        updateSaveButtonState()
    }
    
    func showAlert(err: UserControllerError) {
        alertLabel.text = err.localizedDescription
        alertLabel.isHidden = false
    }
    
    func hideAlert() {
        alertLabel.isHidden = true
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        verifyPassword()
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        guard let password = passwordTextField.text, let p2 = otherPasswordTextField.text else {return}
        let meetsRequirements = !(password.isEmpty || p2.isEmpty) && passwordIsValid
        saveButton.isEnabled = meetsRequirements
    }
    
    @IBAction func savePressd(_ sender: Any) {
        MigrationController.shared.changePassword(new: passwordTextField.text!) { err in
            if let err = err {
                print(err)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordTextField:
            otherPasswordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
