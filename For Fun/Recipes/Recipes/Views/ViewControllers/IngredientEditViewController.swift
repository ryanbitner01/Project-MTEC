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
    
    var units: [String] = ["", "tsp", "tbl", "fl oz", "c", "pt", "qt", "gal", "ml", "l", "dl", "lb", "oz", "mg", "g", "kg"]
    var quantities: [String] = [""]
    var partMeasurments: [String] = ["1/8" ,"1/2", "1/4", "2/3", "1/3", "3/4"]
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
        unit = ""
        quantity = ""
        // Do any additional setup after loading the view.
    }
    
    func setupUnits() {
        let sortedUnits = units.sorted()
        self.units = sortedUnits
    }
    
    func setupPartMeasurements() {
        let sortedMeasurements = partMeasurments.sorted()
        partMeasurments = sortedMeasurements
    }
    
    func setupQuantities() {
        for index in 1...25 {
            quantities.append("\(index)")
            for partMeasure in partMeasurments {
                quantities.append("\(index) \(partMeasure)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        setupNameTF()
        setupSaveButton()
        setupUnitPicker()
        setupQuantityPicker()
        setupUnits()
        setupPartMeasurements()
        setupQuantities()
        unitPicker.reloadAllComponents()
        quantityPicker.reloadAllComponents()
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
