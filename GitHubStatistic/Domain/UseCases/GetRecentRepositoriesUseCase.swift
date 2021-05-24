//
//  GetRecentRepositoriesUseCase.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 30/04/2021.
//

import Foundation
import RxSwift

protocol GetRecentRepositoriesUseCaseProtocol {
    func execute() -> Single<[GitRepository]>
}

class GetRecentRepositoriesUseCase : GetRecentRepositoriesUseCaseProtocol {
    
    private let gitRepoSearchRepository:GitRepoSearchRepositoryProtocol
    
    init(gitRepoSearchRepository:GitRepoSearchRepositoryProtocol) {
        self.gitRepoSearchRepository = gitRepoSearchRepository
    }
    
    public func execute() -> Single<[GitRepository]> {
        let repository: GitRepository = GitRepository(image: "", url: "", name: "Example 1", owner: "user1", numberOfCommits: 24)
        let repository2: GitRepository = GitRepository(image: "", url: "", name: "Example 2", owner: "Very long user name", numberOfCommits: 35)
        let repository3: GitRepository = GitRepository(image: "", url: "", name: "Very long name example", owner: "Short", numberOfCommits: 2)
        let repository4: GitRepository = GitRepository(image: "", url: "", name: "Short", owner: "user4", numberOfCommits: 123)
        let repository5: GitRepository = GitRepository(image: "", url: "", name: "Example 5", owner: "User 5", numberOfCommits: 1240)
        return Observable.just([repository, repository2, repository3, repository4, repository5]).asSingle()
    }
}
