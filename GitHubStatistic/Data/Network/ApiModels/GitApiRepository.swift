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
    var name, fullName: String?
    var privateAccess: Bool?
    var owner: RepositoryOwner?
    var htmlURL: String?
    var fork: Bool?
    var url: String?
    var commitsURL: String?
    var createdAt, updatedAt, pushedAt: Date?
    var size: Int?
    var language: String?
}

extension GitApiRepository: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        identification <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        privateAccess <- map["private"]
        owner <- map["owner"]
        htmlURL <- map["html_url"]
        fork <- map["fork"]
        url <- map["url"]
        commitsURL <- map["commits_url"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        pushedAt <- map["pushed_at"]
        size <- map["size"]
        language <- map["language"]
    }
}

