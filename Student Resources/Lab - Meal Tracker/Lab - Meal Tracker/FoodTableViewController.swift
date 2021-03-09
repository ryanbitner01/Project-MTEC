//
//  FoodTableViewController.swift
//  Lab - Meal Tracker
//
//  Created by Ryan Bitner on 3/9/21.
//

import UIKit

class FoodTableViewController: UITableViewController {
    
    var meals: [Meal] {
        let breakfast = Meal(name: "Breakfast", food: [
            Food(name: "Eggs and Bacon", description: "Delicious Bacon and Scrambled Eggs."),
            Food(name: "Pancakes", description: "Pancakes with Maple Syrup"),
            Food(name: "French Toast", description: "French Toast with powdered sugar served with syrup.")
        ])
        let lunch = Meal(name: "Lunch", food: [
            Food(name: "Ham Sandwhich", description: "Ham sandwhich on wheat bread with mayo, ham, cheese, and letuce"),
            Food(name: "Ramen Noodles", description: "Your ordinary ramen noodles."),
            Food(name: "Hot Pocket", description: "Delicious Pepporoni Hot pocket")
        ])
        let dinner = Meal(name: "Dinner", food: [
            Food(name: "Pork Chops", description: "Pork Chops seasoned with garlic salt. Served with cheesey noodles."),
            Food(name: "Orange Chicken", description: "Orange Chicken, served over white rice."),
            Food(name: "Chicken Alfredo", description: "Chicken Alfredo")
        ])
        
        return [breakfast, lunch, dinner]
    }

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
        return meals.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mealCount = meals[section].food.count
        return mealCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Food", for: indexPath)
        let meal = meals[indexPath.section]
        let food = meal.food[indexPath.row]
        
        cell.textLabel?.text = food.name
        cell.detailTextLabel?.text = food.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return meals[section].name
    }

}
