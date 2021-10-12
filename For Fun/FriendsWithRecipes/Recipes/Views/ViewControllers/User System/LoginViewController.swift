//
//  LoginViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 4/23/21.
//

import UIKit
import UserMessagingPlatform
import GoogleMobileAds

class LoginViewController: UIViewController {
    
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var staySignedInButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    
    //var canLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        self.hideKeyboardTappedAround()
        getRememberedEmail()
        getSignedIn()
        clearBadge()
        addConsent()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        alertLabel.isHidden = true
        

    }
    
    func clearBadge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func getSignedIn() {
        if UserControllerAuth.shared.getStaySignedIn() {
            staySignedInButton.isSelected = true
            getSignedInUser()
        }
    }
    
    func addConsent() {
        
        // Create a UMPRequestParameters object.
        let parameters = UMPRequestParameters()
        // Set tag for under age of consent. Here false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false
        // Request an update to the consent information.
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { [self] error in

              // The consent information has updated.
              if error != nil {
                // Handle the error.
              } else {
                // The consent information state was updated.
                // You are now ready to see if a form is available.
                let formStatus = UMPConsentInformation.sharedInstance.formStatus
                if formStatus == UMPFormStatus.available {
                  loadForm()
                }
              }
            })
    }
    
    func loadForm() {
      UMPConsentForm.load(completionHandler: { form, loadError in
        if loadError != nil {
          // Handle the error.
        } else {
          // Present the form. You can also hold on to the reference to present
          // later.
          if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
            form?.present(
                from: self,
                completionHandler: { dismissError in
                  if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                    // App can start requesting ads.
                  }

                })
          } else {
            // Keep the form available for changes to user consent.
          }
        }
      })
    }
    
    func getSignedInUser() {
        guard let user = UserControllerAuth.shared.getUserStillSignedIn() else {return}
        usernameTextField.text = user.email
        passwordTextField.text = user.userPassword
        login(password: user.userPassword, email: user.email)
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
    
    func login(password: String, email: String) {
        UserControllerAuth.shared.loginUser(email: email, password: password) { err in
            if let err = err {
                DispatchQueue.main.async {
                    self.showAlert(message: err.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoginUser", sender: self)
                    print("Login Successful")
                }
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = usernameTextField.text, let password = passwordTextField.text else {return}
        login(password: password, email: email)
    }
    
    @IBAction func logoutUnwind(_ unwindSegue: UIStoryboardSegue) {
        UserControllerAuth.shared.logoutUser()
        usernameTextField.text = ""
        passwordTextField.text = ""
        staySignedInButton.isSelected = false
        rememberMeButton.isSelected = false
        rememberEmail()
        staySignedIn()
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func donePressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func staySignedInPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        rememberMeButton.isSelected = sender.isSelected
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
    
    func staySignedIn() {
        if staySignedInButton.state == .selected {
            UserControllerAuth.shared.staySignedIn(email: usernameTextField.text!, password: passwordTextField.text!, staySignedIn: true)
        } else if staySignedInButton.state == .normal {
            UserControllerAuth.shared.staySignedIn(email: "", password: "", staySignedIn: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        rememberEmail()
        staySignedIn()
    }
    
}
