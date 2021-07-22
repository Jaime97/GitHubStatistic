//
//  GitApiRepository.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 17/05/2021.
//


import Foundation

struct GitApiRepository: Codable {
    let identification: Int?
    let name, fullName: String?
    let privateAccess: Bool?
    let owner: RepositoryOwner?
    let htmlURL: String?
    let fork: Bool?
    let url: String?
    let commitsURL: String?
    let createdAt, updatedAt, pushedAt: Date?
    let size: Int?
    let language: String?

    enum CodingKeys: String, CodingKey {
        case identification = "id"
        case name
        case fullName = "full_name"
        case privateAccess = "private"
        case owner
        case htmlURL = "html_url"
        case fork, url
        case commitsURL = "commits_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case size
        case language
    }
}


