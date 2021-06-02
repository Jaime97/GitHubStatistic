//
//  GetRecentRepositoriesUseCase.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 30/04/2021.
//

import Foundation
import RxSwift

protocol GetRecentRepositoriesUseCaseProtocol {
    func execute() -> Observable<[GitRepository]>
}

class GetRecentRepositoriesUseCase : GetRecentRepositoriesUseCaseProtocol {
    
    private let gitRepoSearchRepository:GitRepoSearchRepositoryProtocol
    
    init(gitRepoSearchRepository:GitRepoSearchRepositoryProtocol) {
        self.gitRepoSearchRepository = gitRepoSearchRepository
    }
    
    public func execute() -> Observable<[GitRepository]> {
        return self.gitRepoSearchRepository.getRecentlyAccessedRepositories()
    }
}
