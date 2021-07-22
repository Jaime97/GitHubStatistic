//
//  GitApiError.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 09/06/2021.
//

import Foundation

struct GitApiError : Codable {
    var message: String?
    var errors: [ErrorModel]?
    var documentationURL: String?
    
    init(message: String) {
        self.message = message
    }
}

// MARK: - Error
struct ErrorModel : Codable {
    var resource, field, code: String?
}
