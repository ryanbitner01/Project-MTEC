//
//  RecipeDetailViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/3/21.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case ingredients
        case steps
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var recipe: Recipe?
    var book: Book?
    
    @IBOutlet weak var contentTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentTableView.dataSource = self
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        if let recipe = recipe {
            nameLabel.text = recipe.name
        }
        guard let book = book else {return}
        if !book.isShared {
            fetchIngredients()
            fetchInstructions()
        } else {
            
        }
        
        setupImageView()
        checkShared()
    }
    
    func checkShared() {
        guard let book = book else {return}
        let owner = BookController.shared.isOwner(book: book)
        if !owner {
            deleteButton.isHidden = true
            editButton.isHidden = true
        }
    }
    
    func setupImageView() {
        recipeImageView.layer.cornerRadius = 25
        guard let recipe = recipe else {return}
        if let image = recipe.image {
            recipeImageView.image = UIImage(data: image)
        } else if let imageURL = recipe.imageURL, imageURL != "" {
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
    }
    
    func fetchInstructions() {
        guard let user = UserControllerAuth.shared.user, let recipe = recipe, let book = book else {return}
        let isOwner = book.owner == user.id
        var path: FireBasePath = .album
        if !isOwner {
            path = .sharedAlbum
        }
        RecipeController.shared.getInstructions(user: user, recipe: recipe, book: book, path: path) { result in
            switch result {
            case .success(let steps):
                recipe.instruction = steps
                DispatchQueue.main.async {
                    self.contentTableView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func fetchIngredients() {
        guard let user = UserControllerAuth.shared.user, let recipe = recipe, let book = book else {return}
        let isOwner = book.owner == user.id
        var path: FireBasePath = .album
        if !isOwner {
            path = .sharedAlbum
        }
        RecipeController.shared.getIngredients(user: user, recipe: recipe, book: book, path: path) { result in
            switch result {
            case .success(let ingredients):
                recipe.ingredients = ingredients
                DispatchQueue.main.async {
                    self.contentTableView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this recipe?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.performSegue(withIdentifier: "DELETERecipe", sender: self)
        })
        alertController.addAction(cancel)
        alertController.addAction(deleteAction)
        alertController.popoverPresentationController?.sourceView = self.view
        present(alertController, animated: true, completion: nil)
    }
    
    @IBSegueAction func segueToEditRecipe(_ coder: NSCoder, sender: Any?) -> CreateRecipeViewController? {
        guard let recipe = self.recipe else {return nil}
        let createRecipeViewController = CreateRecipeViewController(coder: coder)
        createRecipeViewController?.recipe = recipe
        createRecipeViewController?.book = book
        createRecipeViewController?.ingredients = recipe.ingredients
        if recipe.image != nil {
            createRecipeViewController?.image = recipeImageView.image
        }
        createRecipeViewController?.steps = recipe.instruction
        return createRecipeViewController
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
            return recipe?.ingredients.count ?? 0
        case .steps:
            return recipe?.instruction.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = Section(rawValue: indexPath.section)!
        switch tableSection {
        case .ingredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientCell
            let unit = recipe?.ingredients[indexPath.row].unit ?? ""
            let quantity = recipe?.ingredients[indexPath.row].quantity ?? ""
            let partQuantity = recipe?.ingredients[indexPath.row].partQuantity ?? ""
            cell.nameLabel.text =  "\(quantity) \(partQuantity) \(unit) \(recipe?.ingredients[indexPath.row].name ?? "")"
            //cell.nameLabel.isUserInteractionEnabled = false
            return cell
        case .steps:
            let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell", for: indexPath) as! StepCell
            let step = recipe?.instruction[indexPath.row]
            let order = step?.order
            cell.stepImageView?.image = UIImage(systemName: "\(order ?? 0).circle")
            cell.descriptionLabel.text = step?.description
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
