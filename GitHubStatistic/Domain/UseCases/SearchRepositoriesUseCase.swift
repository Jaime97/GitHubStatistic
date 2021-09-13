//
//  SearchRepositoryUseCase.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 06/05/2021.
//

import Foundation
import RxSwift

enum TypeOfSearch {
    case byRepositoryName
    case byOwner
}

protocol SearchRepositoriesUseCaseProtocol {
    func execute(nameToSearch:String, typeOfSearch:TypeOfSearch) -> Observable<GitRepositoryListResult>
}

class SearchRepositoriesUseCase : SearchRepositoriesUseCaseProtocol {
    
    private let gitRepoSearchRepository:GitRepoSearchRepositoryProtocol
    private let logger : LoggerProtocol
    
    init(gitRepoSearchRepository:GitRepoSearchRepositoryProtocol, logger: LoggerProtocol) {
        self.logger = logger
        self.gitRepoSearchRepository = gitRepoSearchRepository
    }
    
    public func execute(nameToSearch:String, typeOfSearch:TypeOfSearch) -> Observable<GitRepositoryListResult> {
        return ((typeOfSearch == .byRepositoryName) ? self.gitRepoSearchRepository.getRepositoriesByName(nameToSearch: nameToSearch, whereToSearch: Constants.Data.nameParameterValue) : self.gitRepoSearchRepository.getRepositoriesByUser(userToSearch: nameToSearch))
    }
}
