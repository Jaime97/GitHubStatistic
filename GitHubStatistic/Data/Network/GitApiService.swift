//
//  GitApiService.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 13/05/2021.
//

import Foundation
import RxAlamofire
import RxSwift
import ObjectMapper

protocol GitApiServiceProtocol {
    
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<[GitApiRepository]?>
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<[GitApiRepository]?>
    
}

class GitApiSevice: GitApiServiceProtocol {
    
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<[GitApiRepository]?> {
        return RxAlamofire.json(.get,
                                Constants.Data.gitApiUrl + Constants.Data.gitApiSearchPath,
                                parameters: [Constants.Data.searchParameter: nameToSearch, Constants.Data.whereToSearchParameter: whereToSearch]).map { json -> [GitApiRepository]? in
                                        /*guard let gitRepositoryList = Mapper<GitApiRepository>().mapArray(JSONObject: json) else {
                                            //throw ApiError(message: "ObjectMapper can't mapping", code: 422)
                                            throw Error
                                        }*/
                                    let response = Mapper<GitApiSearchResponse>().map(JSONObject: json)!
                                    return response.items
                                }
    }
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<[GitApiRepository]?> {
        return RxAlamofire.json(.get, Constants.Data.gitApiUrl + Constants.Data.gitApiUsernamePath.replacingOccurrences(of: "{username}", with: userToSearch)).map { json -> [GitApiRepository]? in
            /*guard let gitRepositoryList = Mapper<GitApiRepository>().mapArray(JSONObject: json) else {
                //throw ApiError(message: "ObjectMapper can't mapping", code: 422)
                throw Error
            }*/
            return Mapper<GitApiRepository>().mapArray(JSONObject: json)!
        }
    }
}
