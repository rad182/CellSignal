//
//  ComplicationController.swift
//  Watch Extension
//
//  Created by Royce Albert Dy on 14/11/2015.
//  Copyright © 2015 rad182. All rights reserved.
//

import ClockKit
import WatchConnectivity

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler(.None)
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(NSDate())
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Call the handler with the current timeline entry
        switch complication.family {
        case .ModularSmall:
            let smallStackTextTemplate = CLKComplicationTemplateModularSmallStackText()
            if let currentSession = SessionUtility.currentSession where currentSession.reachable {
                if let currentRadioAccessTechnology = SessionUtility.currentRadioAccessTechnology where currentRadioAccessTechnology.isEmpty == false {
                    smallStackTextTemplate.line1TextProvider = CLKSimpleTextProvider(text: "\(SessionUtility.currentSignalStrengthPercentage) %")
                    smallStackTextTemplate.line2TextProvider = CLKSimpleTextProvider(text: currentRadioAccessTechnology)
                } else {
                    smallStackTextTemplate.line1TextProvider = CLKSimpleTextProvider(text: "No")
                    smallStackTextTemplate.line2TextProvider = CLKSimpleTextProvider(text: "Signal")
                }
            } else {
                smallStackTextTemplate.line1TextProvider = CLKSimpleTextProvider(text: "No")
                smallStackTextTemplate.line2TextProvider = CLKSimpleTextProvider(text: "Conn")
            }
            let timelineEntry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: smallStackTextTemplate)
            handler(timelineEntry)
        default:
            handler(nil)
        }
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        // Update 5 mins
        handler(NSDate(timeIntervalSinceNow: 60 * 5))
    }
    
    func requestedUpdateDidBegin() {
        print("requestedUpdateDidBegin")
        SessionUtility.reloadComplicationData()
    }
    
    func requestedUpdateBudgetExhausted() {
        print("requestedUpdateBudgetExhausted")
        SessionUtility.reloadComplicationData()
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        var template: CLKComplicationTemplate? = nil
        switch complication.family {
        case .ModularSmall:
            let simpleTextTemplate = CLKComplicationTemplateModularSmallSimpleText()
            simpleTextTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            template = simpleTextTemplate
        case .CircularSmall:
            let simpleTextTemplate = CLKComplicationTemplateCircularSmallSimpleText()
            simpleTextTemplate.textProvider = CLKSimpleTextProvider(text: "--")
            template = simpleTextTemplate
        default:
            template = nil
        }
        
        handler(template)
    }
    
}