//
//  ViewController.swift
//  TableView Practice
//
//  Created by Ryan Bitner on 3/11/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tvShowController = TVShowController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

//MARK: Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvShowController.shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVShowTableViewCell.reuseIdentifier) as! TVShowTableViewCell
        let tvShow = tvShowController.shows[indexPath.row]
        cell.update(with: tvShow)
        return cell
    }
    
    
}

