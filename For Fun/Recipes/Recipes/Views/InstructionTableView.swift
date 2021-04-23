//
//  InstructionTableView.swift
//  Recipes
//
//  Created by Ryan Bitner on 4/20/21.
//

import UIKit

class InstructionTableView: UITableView, UITableViewDataSource {
    
    var recipe: Recipe?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let recipe = recipe else {return 0}
            return recipe.instruction.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
            guard let recipe = recipe else {return UITableViewCell()}
            cell.textLabel?.text = String(indexPath.row - 1)
            cell.detailTextLabel?.text = recipe.instruction[indexPath.row].descrtiption
            return cell
        default:
            let cell = dequeueReusableCell(withIdentifier: "addInstructionCell", for: indexPath)
            return cell
        }
    }
    

    

}
