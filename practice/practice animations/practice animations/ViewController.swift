//
//  ViewController.swift
//  practice animations
//
//  Created by Ryan Bitner on 3/26/21.
//

import UIKit

class ViewController: UIViewController {
    
    let square = UIView(frame: CGRect(x: 0, y: 0, width: 160, height: 160) )

    override func viewDidLoad() {
        super.viewDidLoad()
        self.square.backgroundColor = UIColor.black
        self.square.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(self.square)
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSquare))
    }
    
    @objc
    func didTapSquare() {
        UIView.animate(withDuration: m, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
    }

}

