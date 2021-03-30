//
//  ContactDetailTableViewController.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import UIKit

class ContactDetailTableViewController: UITableViewController, UITextFieldDelegate {
    //MARK: Outlets
    
    var contact: Contact?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var isFriendSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButton()
        configureTextFields()
        if let contact = contact {
            navigationItem.title = "Contact"
            nameTextField.text = contact.name
            numberTextField.text = contact.number
            emailTextField.text = contact.email ?? ""
            isFriendSwitch.isOn = contact.isFriend
        }
    }
    
    func updateSaveButton() {
        if let nameText = nameTextField.text, let numberText = numberTextField.text {
            if nameText.isEmpty || numberText.isEmpty {
                saveButton.isEnabled = false
            } else {
                saveButton.isEnabled = true
            }
        }
    }
    
    func configureTextFields() {
        nameTextField.delegate = self
        numberTextField.delegate = self
        emailTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let name = nameTextField.text!
        let number = numberTextField.text!
        let email = emailTextField.text ?? nil
        let isFriend = isFriendSwitch.isOn
        
        contact = Contact(name: name, number: number, email: email, isFriend: isFriend)
    }
    
    //MARK: Actions
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func isFriendSwitchChanged(_ sender: UISwitch) {
        updateSaveButton()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}
