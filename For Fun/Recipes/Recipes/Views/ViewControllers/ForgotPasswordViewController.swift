//
//  ForgotPasswordViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/14/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        UserControllerAuth.shared.sendPasswordReset(email: emailTextField.text!) { err in
            if err != nil {
                print(err?.localizedDescription)
            }
        }
        performSegue(withIdentifier: "SEND", sender: self)
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
