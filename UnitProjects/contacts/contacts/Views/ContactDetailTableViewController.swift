//
//  ContactDetailTableViewController.swift
//  contacts
//
//  Created by Ryan Bitner on 3/29/21.
//

import UIKit

class ContactDetailTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Outlets
    
    var contact: Contact?
    
    @IBOutlet weak var contactImageView: UIImageView!
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
            guard let imageData = contact.image else {return}
            contactImageView.image = UIImage(data: imageData)
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
        let isFriend = isFriendSwitch.isOn
        let email = emailTextField.text ?? ""
        guard let contactPhoto = contactImageView.image else {return}
        let imageData: Data = contactPhoto.pngData()!
        
        if let contact = self.contact {
            var editedContact = Contact(name: name, number: number, email: email, isFriend: isFriend, contactPhoto: imageData)
            editedContact.ID = contact.ID
            self.contact = editedContact
        } else {
            contact = Contact(name: name, number: number, email: email, isFriend: isFriend, contactPhoto: imageData)
        }
    }
    
    //MARK: Actions
    
    @IBAction func contactTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let libraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(libraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = self.view
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButton()
    }
    
    @IBAction func isFriendSwitchChanged(_ sender: UISwitch) {
        updateSaveButton()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Text field delegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    // Image picker controller
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        contactImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
}

