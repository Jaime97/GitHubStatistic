//
//  MockSearchRepositoriesUseCase.swift
//  GitHubStatisticTests
//
//  Created by Jaime Alcántara on 04/09/2021.
//

import Foundation
import RxSwift
@testable import GitHubStatistic

class MockSearchRepositoriesUseCase: SearchRepositoriesUseCaseProtocol {
    
    var repositoryList:Observable<GitRepositoryListResult>?
    
    func execute(nameToSearch:String, typeOfSearch:TypeOfSearch) -> Observable<GitRepositoryListResult> {
        let defaultErrorResponse: GitApiResult<GitApiSuccessResponse, GitApiError> = .failure(GitApiError(message: "Failed to decode data."))
        return repositoryList ?? Observable<GitRepositoryListResult>.just(defaultErrorResponse.maptoGitRepositoryListResult())
    }
    
}
