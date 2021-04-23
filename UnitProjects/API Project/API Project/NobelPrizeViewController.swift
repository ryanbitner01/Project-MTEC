//
//  NobelPrizeViewController.swift
//  API Project
//
//  Created by Ryan Bitner on 4/23/21.
//

import UIKit

class NobelPrizeViewController: UIViewController {
    
    let controller = APIController()
    var prize: NobelPrize?

    @IBOutlet weak var categoryTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var nobelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nobelTableView.dataSource = self
        nobelTableView.delegate = self
        updateUI(year: "2010", category: "chemistry")
    }
    
    func updateUI(year: String, category: String) {
        controller.fetchNobelPrizeWinner(year: year, category: category) { (result) in
            switch result {
            case .success(let nobelPrizes):
                self.prize = nobelPrizes[0]
                DispatchQueue.main.async {
                    self.nobelTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
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


extension NobelPrizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let prize = self.prize else {return 0}
        return prize.laureates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nobelCell", for: indexPath) as! NobelTableViewCell
        guard let prize = self.prize else {return UITableViewCell()}
        let prizeWinners = prize.laureates[indexPath.row]
        cell.configure(name: prizeWinners.fullname, category: prize.category, year: prize.year)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
}