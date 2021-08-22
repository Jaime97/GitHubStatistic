//
//  OSLogger.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 22/08/2021.
//

import Foundation
import OSLog

class OSLogger:LoggerProtocol {
    
    public struct Defaults {
        public static let category = LogCategory.defaultLog
        public static let isPrivate = false
    }
    
    private static var subsystem = Bundle.main.bundleIdentifier ?? "Logger"
    private let logger: Logger
    
    
    required init(category: LogCategory = Defaults.category) {
        self.logger = Logger(subsystem: Self.subsystem, category: category.rawValue)
    }
    
    func logDebug(event: String, isPrivate: Bool = Defaults.isPrivate) {
        if isPrivate {
            self.logger.debug("\(event, privacy: .private)")
        } else {
            self.logger.debug("\(event, privacy: .public)")
        }
    }
    
    func logError(event: String, isPrivate: Bool = Defaults.isPrivate) {
        if isPrivate {
            self.logger.error("\(event, privacy: .private)")
        } else {
            self.logger.error("\(event, privacy: .public)")
        }
    }
    
    func logInfo(event: String, isPrivate: Bool = Defaults.isPrivate) {
        if isPrivate {
            self.logger.info("\(event, privacy: .private)")
        } else {
            self.logger.info("\(event, privacy: .public)")
        }
    }
    
}
