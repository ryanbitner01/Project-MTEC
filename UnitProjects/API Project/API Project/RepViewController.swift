//
//  RepViewController.swift
//  API Project
//
//  Created by Ryan Bitner on 4/23/21.
//

import UIKit

class RepViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var representatives: [Representative] = []
    let controller = APIController()
    var zip = ""
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var repTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.repTableView.delegate = self
        self.repTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateUI() {
        controller.fetchRepresentatives(zip: zip) { (result) in
            switch result {
            case .success(let reps):
                self.representatives = reps
                DispatchQueue.main.async {
                    self.repTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Representatitives"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        representatives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repCell") as? RepTableViewCell else {return UITableViewCell()}
        let rep = representatives[indexPath.row]
        cell.configure(name: rep.name, state: rep.state, office: rep.office)
        return cell
    }
    
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
        guard let searchText = searchTextField.text else {return}
        zip = searchText
        updateUI()
    }
}

