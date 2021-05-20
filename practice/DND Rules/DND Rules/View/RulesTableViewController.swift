//
//  RulesTableViewController.swift
//  DND Rules
//
//  Created by Ryan Bitner on 5/11/21.
//

import UIKit

class RulesTableViewController: UITableViewController {
    
    var rules: [Rule] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RuleController.shared.fetchRules { result in
            switch result {
            case .success(let rules):
                self.rules = rules
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                self.rules = []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rules.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RuleCell", for: indexPath)
        let rule = rules[indexPath.row]
        cell.textLabel?.text = rule.name
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSubsections", let subSectionVC = segue.destination as? SubsectionsTableViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            subSectionVC.rule = rules[indexPath.row]
            
        }
    }
}
