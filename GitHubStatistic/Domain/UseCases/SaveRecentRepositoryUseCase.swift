//
//  SaveRecentRepositoryUseCase.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 02/06/2021.
//

import Foundation
import RxSwift

protocol SaveRecentRepositoryUseCaseProtocol {
    func execute(recentRepository:GitRepository)
}

class SaveRecentRepositoryUseCase : SaveRecentRepositoryUseCaseProtocol {
    
    private let gitRepoSearchRepository:GitRepoSearchRepositoryProtocol
    
    init(gitRepoSearchRepository:GitRepoSearchRepositoryProtocol) {
        self.gitRepoSearchRepository = gitRepoSearchRepository
    }
    
    func execute(recentRepository: GitRepository) {
        self.gitRepoSearchRepository.addRecentlyAccessedRepository(repository: recentRepository)
    }
    
    
}
