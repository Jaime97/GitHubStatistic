//
//  GitApiSearchResponse.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 21/05/2021.
//

import Foundation

struct GitApiSuccessResponse : Codable {
    
    var totalCount:Int
    var incompleteResults:Bool
    var repositoryItems:[GitApiRepository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case repositoryItems = "items"
    }
    
}
