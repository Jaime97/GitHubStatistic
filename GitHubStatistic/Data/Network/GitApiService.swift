//
//  GitApiService.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 13/05/2021.
//

import Foundation
import RxAlamofire
import RxSwift

protocol GitApiServiceProtocol {
    
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<GitApiResult<GitApiSuccessResponse, GitApiError>>
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<GitApiResult<[GitApiRepository], GitApiError>>
    
}

class GitApiSevice: GitApiServiceProtocol {
    
    private let logger : LoggerProtocol
    
    init(logger: LoggerProtocol) {
        self.logger = logger
    }
    
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<GitApiResult<GitApiSuccessResponse, GitApiError>> {
        return RxAlamofire.request(.get, Constants.Data.gitApiUrl + Constants.Data.gitApiSearchPath,
                         parameters: [Constants.Data.searchParameter: nameToSearch, Constants.Data.whereToSearchParameter: whereToSearch]).responseData().expectingObject(ofType: GitApiSuccessResponse.self)
    }
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<GitApiResult<[GitApiRepository], GitApiError>> {
        return RxAlamofire.request(.get, Constants.Data.gitApiUrl + Constants.Data.gitApiUsernamePath.replacingOccurrences(of: "{username}", with: userToSearch)).responseData().expectingObject(ofType: [GitApiRepository].self)
    }
}
