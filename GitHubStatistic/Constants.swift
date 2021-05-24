//
//  Constants.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 19/05/2021.
//

import Foundation

struct Constants {
    struct Data {
        static let gitApiUrl:String = "https://api.github.com"
        static let gitApiSearchPath:String = "/search/repositories"
        static let gitApiUsernamePath:String = "/users/{username}/repos"
        static let searchParameter:String = "q"
        static let whereToSearchParameter:String = "in"
        static let nameParameterValue:String = "name"
        static let resultsPerPageParameter:String = "per_page"
        static let userToSearchParameter:String = "description+org"
    }
}
