//
//  Utility.swift
//  CellSignal
//
//  Created by Royce Albert Dy on 14/11/2015.
//  Copyright © 2015 rad182. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony
import WatchConnectivity
import CoreLocation

let Utility = CSUtility()

class CSUtility: NSObject {
    
    private let telephonyInfo = CTTelephonyNetworkInfo()
    private var session: WCSession?
    
    override init () {
        super.init()
        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
            self.session!.delegate = self
            self.session!.activateSession()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func applicationDidBecomeActive() {
        self.sendMessageToUpdateComplications()
    }
    
    func currentRadioAccessTechnologyString() -> String? {
        print("currentRadioAccessTechnology: \(self.telephonyInfo.currentRadioAccessTechnology)")
        if let currentRadioAccessTechnology = self.telephonyInfo.currentRadioAccessTechnology {
            var radioAccessTechnology: String?
            switch currentRadioAccessTechnology {
            case CTRadioAccessTechnologyGPRS:
                radioAccessTechnology =  "GPRS"
            case CTRadioAccessTechnologyEdge:
                radioAccessTechnology = "EDGE"
            case CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA:
                radioAccessTechnology = "3G"
            case CTRadioAccessTechnologyLTE:
                radioAccessTechnology = "LTE"
            default:()
            }
            
            return radioAccessTechnology
        }
                
        return nil
    }
    
    func currentSignalStrengthPercentage() -> Float {
        let currentSignalStrength = SignalStrength.currentSignalStrength()
        if currentSignalStrength == 0 {
            return 0
        } else {
            let signalStrength = CSSignalStrengthMaxStrength / Float(currentSignalStrength)
            return signalStrength * 100.0
        }
    }
    
    func sendMessageToUpdateComplications() {
        if let session = self.session where session.reachable {
            session.sendMessage([:], replyHandler: nil, errorHandler: nil)
        } else {
            print("not reachable")
        }
    }
    
}

extension CSUtility: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let request = message["request"] as? String where request == CSCurrentRadioAccessTechnologyAndCurrentSignalStrengthPercentageRequestKey {
            if let currentRadioAccessTechnologyString = Utility.currentRadioAccessTechnologyString() {
                let currentSignalStrengthPercentage = Utility.currentSignalStrengthPercentage()
                replyHandler([CSCurrentRadioAccessTechnologyKey: currentRadioAccessTechnologyString, CSCurrentSignalStrengthPercentageKey: currentSignalStrengthPercentage])
            } else {
                replyHandler([CSCurrentRadioAccessTechnologyKey: "", CSCurrentSignalStrengthPercentageKey: 0])
            }
        }
    }
    
    func sessionReachabilityDidChange(session: WCSession) {
        if session.reachable {
            self.sendMessageToUpdateComplications()
        }
    }

}