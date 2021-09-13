//
//  StepEditViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/7/21.
//

import UIKit

class StepEditViewController: UIViewController {

    @IBOutlet weak var stepTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var step: Step?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.hideKeyboardTappedAround()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        setupTextView()
        setupSaveButton()
    }
    
    func setupTextView() {
        stepTextView.layer.borderWidth = 2
        stepTextView.layer.borderColor = UIColor(named: "tintColor")?.cgColor
        stepTextView.layer.cornerRadius = 5
        
        if let step = step {
            stepTextView.text = step.description
        }
    }
    
    func setupSaveButton() {
        saveButton.layer.cornerRadius = 15
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor(named: "tintColor")?.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if step != nil {
            self.step?.description = stepTextView.text
        }
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
