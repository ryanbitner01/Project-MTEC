//
//  RecipeDetailViewController.swift
//  Recipe Prototype
//
//  Created by Ryan Bitner on 5/20/21.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case ingredients
        case steps
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var ingredients: [Ingredient] = []
    var steps: [Step] = []
    
    @IBOutlet weak var contentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fakeRecipe = Recipe.fakeRecipe
        ingredients = fakeRecipe.ingredients
        steps = fakeRecipe.steps
        nameLabel.text = fakeRecipe.name
        contentTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
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

extension RecipeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableSection = Section(rawValue: section) else {return 0}
        switch tableSection {
        case .ingredients:
            return ingredients.count
        case .steps:
            return steps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = Section(rawValue: indexPath.section)!
        switch tableSection {
        case .ingredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
            cell.nameLabel.text = ingredients[indexPath.row].name
            //cell.nameLabel.isUserInteractionEnabled = false
            return cell
        case .steps:
            let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath) as! StepCell
            let step = steps[indexPath.row]
            cell.stepImageView?.image = UIImage(systemName: "\(step.count).circle")
            cell.descriptionLabel.text = step.descripton
            //cell.descriptionLabel.isUserInteractionEnabled = false
            return cell
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
