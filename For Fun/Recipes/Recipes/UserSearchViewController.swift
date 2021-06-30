//
//  UserSearchViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 6/29/21.
//

import UIKit

class UserSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var userTableView: UITableView!
    
    var users: [String] = []
    var queriedPeople: [Profile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
        searchBar.delegate = self
        getUsers()
        // Do any additional setup after loading the view.
    }
    
    func getUsers() {
        UserControllerAuth.shared.getAllDisplayNames { result in
            switch result {
            case .success(let users):
                self.users = users
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            case .failure(let err):
                print(err)
            }
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

extension UserSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queriedPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PersonTableViewCell
        let person = queriedPeople[indexPath.row]
        cell.user = person
        cell.updateCell()
        return cell
    }
    
    
}

extension UserSearchViewController: UISearchBarDelegate {
    
    func search(query: String) {
        let queriedUsers = users.filter({$0.lowercased().contains(query.lowercased())})
        queriedPeople = queriedUsers.compactMap({ email -> Profile? in
            
        })
        userTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        search(query: searchBar.text!)
    }
}
