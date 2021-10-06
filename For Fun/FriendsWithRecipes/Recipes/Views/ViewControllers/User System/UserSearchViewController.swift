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
    var queriedPeople: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
        searchBar.delegate = self
        getUsers()
        self.hideKeyboardTappedAround()
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
    
    @IBSegueAction func segueToProfileSnapshotVC(_ coder: NSCoder, sender: PersonTableViewCell?) -> ProfileSnapshotViewController? {
        guard let sender = sender else {return nil}
        let profile = sender.profile
        let profileSnapshotVC = ProfileSnapshotViewController(coder: coder)
        profileSnapshotVC?.profile = profile
        return profileSnapshotVC
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
        cell.displayName = person
        cell.getEmail()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension UserSearchViewController: UISearchBarDelegate {
    
    func search(query: String) {
        queriedPeople = users.filter({user -> Bool in
            if user != UserControllerAuth.shared.user?.displayName {
                return user.lowercased().contains(query.lowercased())
            } else {
                return false
            }
        })
        userTableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String) {
        search(query: searchBar.text!)
    }
}