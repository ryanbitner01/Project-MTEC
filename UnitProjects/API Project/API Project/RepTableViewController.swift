//
//  RepTableViewController.swift
//  API Project
//
//  Created by Ryan Bitner on 4/22/21.
//

import UIKit

class RepTableViewController: UITableViewController {
    
    var representatives: [Representative] = []
    let controller = APIController()
    var zip = "84020"

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Representatitives"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 1:
            return representatives.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchBarCell") else {return UITableViewCell()}
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "repCell") as? RepTableViewCell else {return UITableViewCell()}
            let rep = representatives[indexPath.row]
            cell.configure(name: rep.name, state: rep.state, office: rep.office)
            return cell
        }
    }

    func updateUI() {
        controller.fetchRepresentatives(zip: zip) { (result) in
            switch result {
            case .success(let reps):
                self.representatives = reps
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        guard let searchText = searchTextField.text else {return}
        zip = searchText
        updateUI()
    }
    
}
