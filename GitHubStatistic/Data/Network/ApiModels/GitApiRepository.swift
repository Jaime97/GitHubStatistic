//
//  GitApiRepository.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 17/05/2021.
//


import Foundation
import ObjectMapper

struct GitApiRepository {
    var identification: Int?
    var nodeID, name, fullName: String?
    var welcomePrivate: Bool?
    var owner: RepositoryOwner?
    var htmlURL: String?
    var fork: Bool?
    var url: String?
    var commitsURL: String?
    var createdAt, updatedAt, pushedAt: Date?
    var size: Int?
}

extension GitApiRepository: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        identification <- map["id"]
        nodeID <- map["nodeID"]
        name <- map["name"]
        fullName <- map["fullName"]
        welcomePrivate <- map["welcomePrivate"]
        owner <- map["owner"]
        htmlURL <- map["htmlURL"]
        fork <- map["fork"]
        url <- map["url"]
        commitsURL <- map["commitsURL"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        pushedAt <- map["pushedAt"]
        size <- map["size"]
    }
}

