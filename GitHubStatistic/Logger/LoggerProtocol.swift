//
//  LoggerProtocol.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 21/08/2021.
//

import Foundation

protocol LoggerProtocol {
    init(category:LogCategory)
    func logDebug(event:String, isPrivate:Bool)
    func logError(event:String, isPrivate:Bool)
    func logInfo(event:String, isPrivate:Bool)
}

enum LogCategory: String, CaseIterable {
    case defaultLog
    case data
    case presentation
    case domain
    case testing
}
