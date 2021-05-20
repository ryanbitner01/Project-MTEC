//
//  NewRecipeViewController.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/20/21.
//

import UIKit

class NewRecipeViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case ingredients
        //case addIngredient
        case steps
        //case addStep
    }
    
    @IBOutlet weak var componentTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var ingredients = [Ingredient]()
    var steps = [Step]()
    
    
    let ingredientSection = 0
    let stepSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension NewRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableSection = Section(rawValue: section) else {return 0}
        switch tableSection {
        case .ingredients:
            return ingredients.count + 1
        //        case .addIngredient:
        //            return 1
        case .steps:
            return steps.count + 1
        //        case .addStep:
        //            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = Section(rawValue: indexPath.section)!
        switch tableSection {
        case .ingredients:
            if indexPath.row < ingredients.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCellEdit
                cell.nameTextField.text = ingredients[indexPath.row].name
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addItemCell", for: indexPath) as! AddItemCell
                cell.delegate = self
                cell.itemType = .ingredient
                return cell
            }
        case .steps:
            if indexPath.row < steps.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath) as! StepCellEdit
                let step = steps[indexPath.row]
                cell.stepImageView?.image = UIImage(systemName: "\(step.count).circle")
                cell.descriptionTextField.text = step.descripton
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addItemCell", for: indexPath) as! AddItemCell
                cell.delegate = self
                cell.itemType = .step
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let tableSection = Section(rawValue: section) else {return nil}
        switch tableSection {
        case .ingredients:
            return "Ingredients"
        case .steps:
            return "Steps"
        }
    }
    
}

extension NewRecipeViewController: AddItemCellDelegate {
    func addItem(text: String, sender: Any) {
        if let cell = sender as? AddItemCell {
            switch cell.itemType {
            case .ingredient:
                let ingredient = Ingredient(name: text, count: ingredients.count + 1)
                ingredients.append(ingredient)
                componentTableView.reloadData()
            case .step:
                let step = Step(descripton: text, count: steps.count + 1)
                steps.append(step)
                componentTableView.reloadData()
            case .none:
                return
            }
        }
    }
    
    
}
