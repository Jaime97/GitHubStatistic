//
//  GitApiSearchResponse.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 21/05/2021.
//

import Foundation
import ObjectMapper

struct GitApiSearchResponse {
    
    var total_count:Int?
    var incomplete_results:Bool?
    var items:[GitApiRepository]?
    
}

extension GitApiSearchResponse: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        total_count <- map["total_count"]
        incomplete_results <- map["incomplete_results"]
        items <- map["items"]
    }
    
}
