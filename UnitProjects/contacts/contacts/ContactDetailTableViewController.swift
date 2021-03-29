//
//  ContactDetailTableViewController.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import UIKit

class ContactDetailTableViewController: UITableViewController, UITextFieldDelegate {
    //MARK: Outlets
    
    var contact: Contact? {
        guard let name = nameTextField.text, let number = numberTextField.text else {return nil}
        let email = emailTextField.text ?? nil
        let isFriend = isFriendSwitch.isOn
        
        return Contact(name: name, number: number, email: email, isFriend: isFriend)
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var isFriendSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButton()
        configureTextFields()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    //MARK: Actions
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}
