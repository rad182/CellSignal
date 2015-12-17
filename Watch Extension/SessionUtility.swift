//
//  WCSession.swift
//  CellSignal
//
//  Created by Royce Albert Dy on 15/11/2015.
//  Copyright © 2015 rad182. All rights reserved.
//

import Foundation
import WatchConnectivity
import ClockKit

let SessionUtility = CSSessionUtility()

class CSSessionUtility: NSObject {
    
    var currentSession: WCSession?
    var currentRadioAccessTechnology: String?
    var currentSignalStrengthPercentage = 0
    
    override init () {
        super.init()
        self.currentSession = WCSession.defaultSession()
        self.currentSession!.delegate = self
        self.currentSession!.activateSession()
    }
    
    // MARK: - Public Methods
    func refreshComplications() {
        let server = CLKComplicationServer.sharedInstance()
        for complication in server.activeComplications {
            server.reloadTimelineForComplication(complication)
        }
    }
    
    func updateCurrentRadioAccessTechnologyAndCurrentSignalStrengthPercentage(completion: ((currentRadioAccessTechnology: String?, currentSignalStrengthPercentage: Int) -> Void)?) {
        if let currentSession = self.currentSession where currentSession.reachable {
            currentSession.sendMessage(["request": CSCurrentRadioAccessTechnologyAndCurrentSignalStrengthPercentageRequestKey],
                replyHandler: { (response) -> Void in
                    print(response)
                    let currentRadioAccessTechnology = response[CSCurrentRadioAccessTechnologyKey] as? String
                    let currentSignalStrengthPercentage = response[CSCurrentSignalStrengthPercentageKey] as! Int
                    completion?(currentRadioAccessTechnology: currentRadioAccessTechnology, currentSignalStrengthPercentage: currentSignalStrengthPercentage)
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        } else {
            completion?(currentRadioAccessTechnology: nil, currentSignalStrengthPercentage: 0)
        }
    }
    
    func reloadComplicationData() {
        if let currentSession = self.currentSession where currentSession.reachable {
            currentSession.sendMessage(["request": CSCurrentRadioAccessTechnologyAndCurrentSignalStrengthPercentageRequestKey],
                replyHandler: { (response) -> Void in
                    print(response)
                    self.currentRadioAccessTechnology = response[CSCurrentRadioAccessTechnologyKey] as? String
                    self.currentSignalStrengthPercentage = response[CSCurrentSignalStrengthPercentageKey] as! Int
                    self.refreshComplications()
                }, errorHandler: { (error) -> Void in
                    print(error)
                    self.refreshComplications()
                }
            )
        } else {
            self.currentRadioAccessTechnology = nil
            self.currentSignalStrengthPercentage = 0
            self.refreshComplications()
        }
    }
}

extension CSSessionUtility: WCSessionDelegate {
    func sessionReachabilityDidChange(session: WCSession) {
        print("sessionReachabilityDidChange \(session.reachable)")
        if session.reachable {
            self.reloadComplicationData()
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        self.reloadComplicationData()
    }
}