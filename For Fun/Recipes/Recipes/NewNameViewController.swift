//
//  NewNameViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 7/15/21.
//

import UIKit

class NewNameViewController: UIViewController {

    @IBOutlet weak var newNameTF: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    
    var displayNameIsValid = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkText()
        updateSaveButtonState()
        updateNameLabel()
        // Do any additional setup after loading the view.
    }
    
    func updateNameLabel() {
        guard let name = UserControllerAuth.shared.user?.displayName else {return}
        nameLabel.text = "Display Name: " + name
    }
    
    func checkText() {
        UserControllerAuth.shared.getAllDisplayNames { result in
            switch result {
            case .success(let names):
                if !names.contains(where: {$0.lowercased() == self.newNameTF.text?.lowercased()}) {
                    self.displayNameIsValid = true
                    self.hideAlert()
                    self.updateSaveButtonState()
                    //self.verifyPassword()
                } else {
                    self.displayNameIsValid = false
                    self.showAlert(err: MigrationError.invalidName)
                    self.updateSaveButtonState()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func updateSaveButtonState() {
        let meetsRequirements = !(newNameTF.text!.isEmpty) && displayNameIsValid
        saveButton.isEnabled = meetsRequirements
    }
    
    func showAlert(err: Error) {
        alertLabel.text = err.localizedDescription
        alertLabel.isHidden = false
    }
    
    func hideAlert() {
        alertLabel.isHidden = true
    }
    
    @IBAction func savePressed(_ sender: Any) {
        MigrationController.shared.changeName(new: newNameTF.text!) { err in
            if let err = err {
                DispatchQueue.main.async {
                    self.showAlert(err: err)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textChanged(_ sender: Any) {
        checkText()
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
