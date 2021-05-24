//
//  RepositoryOwner.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 19/05/2021.
//

import Foundation
import ObjectMapper

struct RepositoryOwner {
    var login: String?
    var id: Int?
    var nodeID: String?
    var avatarURL: String?
    var type: String?
    var siteAdmin: Bool?
}

extension RepositoryOwner: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        login <- map["login"]
        id <- map["id"]
        nodeID <- map["node_id"]
        avatarURL <- map["avatar_url"]
        type <- map["type"]
        siteAdmin <- map["site_admin"]
    }
}
