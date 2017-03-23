//
//  DMXCGLoggerExtension.swift
//  DMShared
//
//  Created by Dima Medynsky on 10/11/16.
//  Copyright © 2016 Dima Medynsky. All rights reserved.
//

import Foundation
import XCGLogger

extension XCGLogger: DMXCGLogger {
    public static var identifier: String { return "DMShared" }
    
    public static var DMXCGLogger: XCGLogger {
        let log = XCGLogger(identifier: identifier, includeDefaultDestinations: false)
        
        
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = false
        systemDestination.showLevel = false
        systemDestination.showFileName = false
        systemDestination.showLineNumber = false
        systemDestination.showDate = false
        
        // Add the destination to the logger
        log.add(destination: systemDestination)
        
        // Add basic app info, version info etc, to the start of the logs
//        log.logAppDetails()
        return log
    }
}
