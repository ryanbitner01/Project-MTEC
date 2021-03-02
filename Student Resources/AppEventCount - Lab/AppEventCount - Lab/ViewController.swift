//
//  ViewController.swift
//  AppEventCount - Lab
//
//  Created by Ryan Bitner on 3/2/21.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Variables
    var willConnectToCount = 0
    var sceneDidBecomeActiveCount = 0
    var sceneWillResignActiveCount = 0
    var sceneWillEnterForegroundCount = 0
    var sceneDidEnterBackgroundCount = 0
    
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    // MARK: Outlets
    @IBOutlet weak var didFinishLaunchingLabel: UILabel!
    @IBOutlet weak var configurationForConnectingLabel: UILabel!
    @IBOutlet weak var willConnectToLabel: UILabel!
    @IBOutlet weak var sceneDidBecomeActiveLabel: UILabel!
    @IBOutlet weak var sceneWillResignActiveLabel: UILabel!
    @IBOutlet weak var sceneWillEnterForegroundLabel: UILabel!
    @IBOutlet weak var sceneDidEnterBackgroundLabel: UILabel!
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Methods
    func updateView() {
        didFinishLaunchingLabel.text = "The App has launched \(appDelegate.launchCount) time(s)"
        configurationForConnectingLabel.text = "The App has loaded the configuration\(appDelegate.configurationForConnectingCount) time(s)"
        willConnectToLabel.text = "Will connect to \(willConnectToCount) time(s)"
        sceneDidBecomeActiveLabel.text = "Did become active \(sceneDidBecomeActiveCount) time(s)"
        sceneWillResignActiveLabel.text = "Will Resign active \(sceneWillResignActiveCount) time(s)"
        sceneWillEnterForegroundLabel.text = "Will enter foreground \(sceneWillEnterForegroundCount) time(s)"
        sceneDidEnterBackgroundLabel.text = "Did enter background \(sceneDidEnterBackgroundCount) time(s)"
    }


}

