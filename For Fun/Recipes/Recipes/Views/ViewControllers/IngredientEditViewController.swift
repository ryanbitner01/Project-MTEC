//
//  IngredientEditViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/7/21.
//

import UIKit

class IngredientEditViewController: UIViewController {
    
    @IBOutlet weak var quantityPicker: UIPickerView!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let units: [String] = ["", "mg", "g", "lbs", "cups", "oz"]
    let quantities: [String] = ["", "1", "2", "3", "4", "5", "6"]
    var ingredient: Ingredient?
    
    var unit: String?
    var quantity: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        //updateUI()
        unitPicker.delegate = self
        unitPicker.dataSource = self
        quantityPicker.delegate = self
        quantityPicker.dataSource = self
        unit = units[0]
        quantity = quantities[0]
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        setupNameTF()
        setupSaveButton()
        setupUnitPicker()
        setupQuantityPicker()
    }
    
    func setupUnitPicker() {
        if let unit = ingredient?.unit, let unitIndex = units.firstIndex(where: {$0 == unit}) {
            unitPicker.selectRow(unitIndex, inComponent: 0, animated: true)
        } else {
            unitPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func setupQuantityPicker() {
        if let quantity = ingredient?.quantity, let quantityIndex = quantities.firstIndex(where: {$0 == quantity}) {
            quantityPicker.selectRow(quantityIndex, inComponent: 0, animated: true)
        } else {
            quantityPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func setupNameTF() {
        if let ingredient = ingredient {
            nameTextField.text = ingredient.name
        }
    }
    
    func setupSaveButton() {
        saveButton.layer.cornerRadius = 15
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor(named: "tintColor")?.cgColor
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ingredient != nil {
            self.ingredient?.name = nameTextField.text!
            self.ingredient?.unit = unit ?? ""
            self.ingredient?.quantity = quantity ?? ""
        }
    }

}

extension IngredientEditViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case quantityPicker:
            return quantities.count
        case unitPicker:
            return units.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case quantityPicker:
            let quantity = quantities[row]
            return quantity
        case unitPicker:
            let unit = units[row]
            return unit
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case unitPicker:
            unit = units[row]
        case quantityPicker:
            quantity = quantities[row]
        default:
            return
        }
    }
}
