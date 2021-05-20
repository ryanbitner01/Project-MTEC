//
//  CreateRecipeViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 5/14/21.
//

import UIKit

enum SectionInt: Int {
    case instruction
    case addInstruction
    
}

class CreateRecipeViewController: UIViewController {
    
    var recipe: Recipe?
    var instructions: [Instruction] = []
    var image: UIImage?
    var book: Book?
    
    @IBOutlet weak var instructionTableView: UITableView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionTableView.dataSource = self
        if let recipe = recipe {
            instructions = recipe.instruction
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func savedTapped(_ sender: Any) {
        saveRecipe()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recipeImageTapped(_ sender: UITapGestureRecognizer) {
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
    
    func saveRecipe() {
        guard let book = book else {return}
        if let image = image {
            let data = image.jpegData(compressionQuality: 0.9)
            let recipe = Recipe(name: nameTextField.text!, image: data, instruction: instructions)
            RecipeController.shared.addRecipeImage(recipe: recipe, book: book, instructions: instructions)
            self.recipe = recipe
        } else {
            let recipe = Recipe(name: nameTextField.text!, instruction: instructions)
            RecipeController.shared.addRecipe(recipe: recipe, book: book, instructions: instructions)
            self.recipe = recipe
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

extension CreateRecipeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionInt.instruction.rawValue:
            return instructions.count
        case SectionInt.addInstruction.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionInt.instruction.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath) as! InstructionCell
            cell.instruction = instructions[indexPath.row]
            cell.updateCell()
            return cell
        case SectionInt.addInstruction.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddInstruction") as! AddInstructionCell
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension CreateRecipeViewController: AddInstructionCellDelegate {
    func addInstruction(description: String, sender: Any) {
        instructions.append(Instruction(order: instructions.count + 1, descrtiption: description))
        instructionTableView.reloadData()
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
