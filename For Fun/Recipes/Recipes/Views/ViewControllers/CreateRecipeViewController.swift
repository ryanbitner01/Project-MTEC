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
        //case addIngredient
        case steps
        //case addStep
    }
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var componentTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var ingredients = [Ingredient]()
    var steps = [Step]()
    var image: UIImage?
    var recipe: Recipe?
    var book: Book?
    
    let ingredientSection = 0
    let stepSection = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentTableView.dataSource = self
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func saveRecipe() {
        guard let book = book else {return}
        if let image = image {
            let data = image.jpegData(compressionQuality: 0.9)
            var recipe = Recipe(name: nameTextField.text!, image: data, instruction: steps, ingredients: ingredients)
            recipe.image = data
            RecipeController.shared.addRecipeImage(recipe: recipe, book: book, instructions: steps, ingredients: ingredients)
            self.recipe = recipe
        } else {
            let recipe = Recipe(name: nameTextField.text!, instruction: steps, ingredients: ingredients)
            RecipeController.shared.addRecipe(recipe: recipe, book: book, instructions: steps, ingredients: ingredients)
            self.recipe = recipe
            
        }
        
    }
    
    func updateUI() {
        nameTextField.text = recipe?.name ?? ""
//        fetchInstructions()
//        fetchIngredients()
        setupImageView()
    }
    
    func setupImageView() {
        guard let recipe = recipe, let imageURL = recipe.imageURL else {return}
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
    }
    
//    func fetchInstructions() {
//        guard let user = UserControllerAuth.shared.user, let recipe = recipe, let book = book else {return}
//        RecipeController.shared.getInstructions(user: user, recipe: recipe, book: book) { result in
//            switch result {
//            case .success(let steps):
//                self.steps = steps
//                DispatchQueue.main.async {
//                    self.componentTableView.reloadData()
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
//
//    func fetchIngredients() {
//        guard let user = UserControllerAuth.shared.user, let recipe = recipe, let book = book else {return}
//        RecipeController.shared.getIngredients(user: user, recipe: recipe, book: book) { result in
//            switch result {
//            case .success(let ingredients):
//                self.ingredients = ingredients
//                DispatchQueue.main.async {
//                    self.componentTableView.reloadData()
//                }
//            case .failure(let err):
//                print(err.localizedDescription)
//            }
//        }
//    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        saveRecipe()
        performSegue(withIdentifier: "unwindToBookDetail", sender: self)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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

extension CreateRecipeViewController: AddItemCellDelegate {
    func addItem(text: String, sender: Any) {
        if let cell = sender as? AddItemCell {
            switch cell.itemType {
            case .ingredient:
                let ingredient = Ingredient(name: text, count: ingredients.count + 1)
                ingredients.append(ingredient)
                componentTableView.reloadData()
            case .step:
                let step = Step(order: steps.count + 1, description: text)
                steps.append(step)
                componentTableView.reloadData()
            case .none:
                return
            }
        }
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
