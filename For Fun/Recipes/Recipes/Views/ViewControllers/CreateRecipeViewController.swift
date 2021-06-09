//
//  CreateRecipeViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/14/21.
//

import UIKit

class CreateRecipeViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case ingredients
        case steps
    }
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var componentTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var ingredients = [Ingredient]()
    var steps = [Step]()
    var image: UIImage? = nil
    var recipe: Recipe?
    var book: Book?
    
    let ingredientSection = 0
    let stepSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentTableView.dataSource = self
        componentTableView.delegate = self
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        updateUI()
        // Do any additional setup after loading the view.
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if !nameTextField.isEditing {
//            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let navBarHeight = self.navigationController?.navigationBar.frame.height {
//                if self.view.frame.origin.y == 0 {
//                    self.view.frame.origin.y -= keyboardSize.height - navBarHeight
//                }
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
    
    func saveRecipe() {
        guard let book = book else {return}
        if let image = image {
            let data = image.jpegData(compressionQuality: 0.9)
            var recipe = Recipe(id: self.recipe?.id ?? UUID(), name: nameTextField.text!, image: data, instruction: steps, ingredients: ingredients)
            recipe.image = data
            RecipeController.shared.addRecipeImage(recipe: recipe, book: book, instructions: steps, ingredients: ingredients)
            self.recipe = recipe
            performSegue(withIdentifier: "Save", sender: self)
        } else {
            let recipe = Recipe(id: self.recipe?.id ?? UUID(), name: nameTextField.text!, instruction: steps, ingredients: ingredients)
            RecipeController.shared.addRecipe(recipe: recipe, book: book, instructions: steps, ingredients: ingredients)
            self.recipe = recipe
            performSegue(withIdentifier: "Save", sender: self)
        }
        
    }
    
    func updateUI() {
        nameTextField.text = recipe?.name ?? ""
        //        fetchInstructions()
        //        fetchIngredients()
        setupImageView()
    }
    
    func setupImageView() {
        recipeImageView.layer.cornerRadius = 25
        guard let recipe = recipe else {return}
        if let imageURL = recipe.imageURL, imageURL != "" {
            RecipeController.shared.getRecipeImage(url: imageURL) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.recipeImageView.image = image
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
        } else if let image = recipe.image {
            recipeImageView.image = UIImage(data: image)
        }
    }
    
    @IBAction func editingDone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        saveRecipe()
        
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        print("IMAGE TAPPED")
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
    
}

extension CreateRecipeViewController: UITableViewDataSource, UITableViewDelegate {
    
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
                let ingredient = ingredients[indexPath.row]
                cell.ingredient = ingredient
                cell.delegate = self
                cell.updateCell()
                //cell.nameTextField.text = ingredients[indexPath.row].name
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
                cell.step = step
                cell.updateCell()
                cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let addItemIngredient = ingredients.count
        let addItemStep = steps.count
        guard let tableSection = Section(rawValue: indexPath.section) else {return false}
        switch tableSection {
        case .ingredients:
            if indexPath.row == addItemIngredient {
                return false
            } else { return true }
        case .steps:
            if indexPath.row == addItemStep {
                return false
            } else {return true}
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let tableSection = Section(rawValue: indexPath.section) else {return}
            switch tableSection {
            case .ingredients:
                let ingredient = ingredients[indexPath.row]
                guard let index = ingredients.firstIndex(where: {$0.count == ingredient.count}), let book = book, let recipe = recipe else {return}
                ingredients.remove(at: index)
                componentTableView.deleteRows(at: [indexPath], with: .automatic)
                RecipeController.shared.deleteIngredient(ingredeint: ingredient, book: book, recipe: recipe)
            case .steps:
                let step = steps[indexPath.row]
                guard let index = steps.firstIndex(where: {$0.order == step.order}), let book = book, let recipe = recipe else {return}
                steps.remove(at: index)
                componentTableView.deleteRows(at: [indexPath], with: .automatic)
                RecipeController.shared.deleteInstruction(instruction: step, book: book, recipe: recipe)
            }
        }
    }
    
}

extension CreateRecipeViewController: AddItemCellDelegate, StepCellEditDelegate, IngredientCellEditDelegate {
    func addItem(sender: Any) {
        guard let cell = sender as? AddItemCell else {return}
        switch cell.itemType {
        case .ingredient:
            performSegue(withIdentifier: "editIngredient", sender: cell)
        case .step:
            performSegue(withIdentifier: "editStep", sender: cell)
        default:
            return
        }
    }
    
    func editStep(sender: Any) {
        guard let cell = sender as? StepCellEdit else {return}
        performSegue(withIdentifier: "editStep", sender: cell)
    }
    
    func editIngredient(sender: Any) {
        guard let cell = sender as? IngredientCellEdit else {return}
        performSegue(withIdentifier: "editIngredient", sender: cell)
    }
    
}

extension CreateRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        recipeImageView.image = selectedImage
        recipeImageView.layer.cornerRadius = 25
        image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: Prepare for segue

extension CreateRecipeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ingredientCellEdit = sender as? IngredientCellEdit {
            guard let destination = segue.destination as? IngredientEditViewController else {return}
            destination.ingredient = ingredientCellEdit.ingredient
        }
        if let stepCellEdit = sender as? StepCellEdit {
            guard let destination = segue.destination as? StepEditViewController else {return}
            destination.step = stepCellEdit.step
        }
        if sender is AddItemCell {
            if let destination = segue.destination as? StepEditViewController {
                destination.step = Step(order: steps.count + 1, description: "")
            } else if let destination = segue.destination as? IngredientEditViewController {
                destination.ingredient = Ingredient(name: "", count: ingredients.count + 1)
            }
        }
    }
}

//MARK: UnwindsFromEdit

extension CreateRecipeViewController {
    @IBAction func unwindFromEditIngredient(_ unwindSegue: UIStoryboardSegue) {
        guard let editIngredientVC = unwindSegue.source as? IngredientEditViewController else {return}
        guard let ingredient = editIngredientVC.ingredient else {return}
        let count = ingredient.count
        if let existingIngredient = ingredients.firstIndex(where: {$0.count == count}) {
            ingredients[existingIngredient] = ingredient
        } else {
            ingredients.append(ingredient)
        }
        componentTableView.reloadData()
        // Use data from the view controller which initiated the unwind segue
    }
    
    @IBAction func unwindFromEditStep(_ unwindSegue: UIStoryboardSegue) {
        guard let editStepVC = unwindSegue.source as? StepEditViewController else {return}
        guard let step = editStepVC.step else {return}
        let order = step.order
        if let existingStep = steps.firstIndex(where: {$0.order == order}) {
            steps[existingStep] = step
        } else {
            steps.append(step)
        }
        componentTableView.reloadData()
        // Use data from the view controller which initiated the unwind segue
    }
}
