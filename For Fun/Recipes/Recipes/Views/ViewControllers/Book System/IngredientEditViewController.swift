//
//  IngredientEditViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/7/21.
//

import UIKit

class IngredientEditViewController: UIViewController {
    
    @IBOutlet weak var quantityPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    enum Component: Int, CaseIterable {
        case wholeInt
        case partInt
        case unit
    }
    
    var units: [String] = ["", "tsp", "tbl", "fl oz", "C", "pt", "qt", "gal", "ml", "l", "dl", "lb", "oz", "mg", "g", "kg", "Box"]
    var quantities: [String] = ["", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    var partMeasurments: [String] = ["", "1/8" ,"1/2", "1/4", "2/3", "1/3", "3/4"]
    var ingredient: Ingredient?
    
    var unit: String?
    var quantity: String?
    var partQuantity: String?

    override func viewDidLoad() {
        self.hideKeyboardTappedAround()
        super.viewDidLoad()
        //updateUI()
        quantityPicker.delegate = self
        quantityPicker.dataSource = self
        unit = ""
        quantity = ""
        partQuantity = ""
        if let ingredient = ingredient {
            unit = ingredient.unit
            quantity = ingredient.quantity
            partQuantity = ingredient.partQuantity
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    func updateUI() {
        setupNameTF()
        setupSaveButton()
        setupUnits()
        setupPartMeasurements()
        setupPicker()
        quantityPicker.reloadAllComponents()
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
    
    func setupPicker() {
        if let quantity = quantity, let index = quantities.firstIndex(where: {$0 == quantity}) {
            print(quantity, index)
            quantityPicker.selectRow(index, inComponent: 0, animated: true)
        }
        if let partQuantity = partQuantity, let index = partMeasurments.firstIndex(where: {$0 == partQuantity}) {
            quantityPicker.selectRow(index, inComponent: 1, animated: true)
        }
        if let unit = unit, let unitIndex = units.firstIndex(where: {$0 == unit}) {
            quantityPicker.selectRow(unitIndex, inComponent: 2, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ingredient != nil {
            self.ingredient?.name = nameTextField.text!
            self.ingredient?.unit = unit ?? ""
            self.ingredient?.quantity = quantity ?? ""
            self.ingredient?.partQuantity = partQuantity ?? ""
        }
    }

}

extension IngredientEditViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let componentInt = Component(rawValue: component) else {return 0}
        switch componentInt {
        case .wholeInt:
            return quantities.count
        case .partInt:
            return partMeasurments.count
        case .unit:
            return units.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let componentInt = Component(rawValue: component) else {return nil}
        switch componentInt {
        case .wholeInt:
            let int = quantities[row]
            return int
        case .partInt:
            let partInt = partMeasurments[row]
            return partInt
        case .unit:
            let unit = units[row]
            return unit
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let componentInt = Component(rawValue: component) else {return}
        switch componentInt {
        case .wholeInt:
            let int = quantities[row]
            quantity = int
        case .partInt:
            let partInt = partMeasurments[row]
            partQuantity = partInt
        case .unit:
            let unit = units[row]
            self.unit = unit
        }
    }
}
