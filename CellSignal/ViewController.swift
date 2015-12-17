//
//  ViewController.swift
//  CellSignal
//
//  Created by Royce Albert Dy on 14/11/2015.
//  Copyright © 2015 rad182. All rights reserved.
//

import UIKit
import CoreTelephony

class ViewController: UIViewController {
    
    @IBOutlet weak var radioAccessTechnologyLabel: UILabel!
    
    private let telephonyInfo = CTTelephonyNetworkInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateRadioAccessTechnologyLabel", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        print(Utility.currentSignalStrengthPercentage())
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateRadioAccessTechnologyLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func updateRadioAccessTechnologyLabel() {
        if let currentRadioAccessTechnology = Utility.currentRadioAccessTechnologyString() where currentRadioAccessTechnology.isEmpty == false {
            self.radioAccessTechnologyLabel.text = currentRadioAccessTechnology
        } else {
            self.radioAccessTechnologyLabel.text = "No Signal"
        }
    }
}

