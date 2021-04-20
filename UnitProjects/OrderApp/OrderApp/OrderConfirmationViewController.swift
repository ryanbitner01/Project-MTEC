//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Ryan Bitner on 4/20/21.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    let minutesToPrepare: Int
    @IBOutlet weak var confirmationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationLabel.text = "Thank you for your order! Your wait time is approximately \(minutesToPrepare) minutes." 
        // Do any additional setup after loading the view.
    }
    
    init?(coder: NSCoder, prepTime: Int) {
        self.minutesToPrepare = prepTime
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
