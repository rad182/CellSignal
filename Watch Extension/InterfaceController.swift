//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Royce Albert Dy on 14/11/2015.
//  Copyright © 2015 rad182. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var radioTechnologyLabel: WKInterfaceLabel!
    private var isFetchingData = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
    }
    
    override func didAppear() {
        super.didAppear()
        print("didAppear")
        self.reloadData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        print("willActivate")
        self.reloadData()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - Methods
    func reloadData() {
        if self.isFetchingData {
            return
        }
        
        SessionUtility.reloadComplicationData()
        
        if let currentSession = SessionUtility.currentSession where currentSession.reachable {
            self.isFetchingData = true
            SessionUtility.updateCurrentRadioAccessTechnologyAndCurrentSignalStrengthPercentage {
                (currentRadioAccessTechnology, currentSignalStrengthPercentage) -> Void in
                self.isFetchingData = false
                if let currentRadioAccessTechnology = currentRadioAccessTechnology where currentRadioAccessTechnology.isEmpty == false {
                    self.radioTechnologyLabel.setText(currentRadioAccessTechnology)
                    SessionUtility.refreshComplications()
                    print(currentRadioAccessTechnology)
                } else {
                    self.radioTechnologyLabel.setText("No Signal")
                }
            }
        } else {
            self.radioTechnologyLabel.setText("Not Reachable")
            print("not reachable")
        }
    }

}