//
//  CreateUserViewController.swift
//  Recipes
//
//  Created by Ryan Bitner on 2/23/21.
//

import UIKit

class CreateUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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


struct User {
    let username: String
    let password: String
    var recipes: [String]
    static var Users: [String: String] = [:]
    
    
}
