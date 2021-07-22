//
//  RepositoryOwner.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 19/05/2021.
//

import Foundation

struct RepositoryOwner: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let type: String?
    let siteAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case type
        case siteAdmin = "site_admin"
    }
}
