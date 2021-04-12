//
//  RecipeListTableViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 4/5/21.
//

import UIKit

class RecipeListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipes.count
    }

    @IBAction func unwindFromAddRecipe(unwindSegue: UIStoryboardSegue) {
        guard let addRecipeController = unwindSegue.source as? AddRecipeTableViewController, let recipe = addRecipeController.recipe else {return}
        let newIndex = IndexPath(row: recipes.count, section: 0)
        recipes.append(recipe)
        tableView.insertRows(at: [newIndex], with: .automatic)
    }

}
