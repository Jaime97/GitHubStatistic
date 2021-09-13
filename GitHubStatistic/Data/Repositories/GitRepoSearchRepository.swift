//
//  GitRepoSearchRepository.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 13/05/2021.
//

import Foundation
import RxSwift

protocol GitRepoSearchRepositoryProtocol {
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<GitRepositoryListResult>
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<GitRepositoryListResult>
    func getRecentlyAccessedRepositories() -> Observable<[GitRepository]>
    func addRecentlyAccessedRepository(repository: GitRepository)
    
}

class GitRepoSearchRepository: GitRepoSearchRepositoryProtocol {

    private let gitApiService: GitApiServiceProtocol
    private let persistentStorageManager: PersistentStorageManagerProtocol
    private let logger : LoggerProtocol
    
    init(gitApiService:GitApiServiceProtocol, persistentStorageManager: PersistentStorageManagerProtocol, logger: LoggerProtocol) {
        self.gitApiService = gitApiService
        self.persistentStorageManager = persistentStorageManager
        self.logger = logger
    }
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<GitRepositoryListResult> {
        return self.gitApiService.getRepositoriesByUser(userToSearch: userToSearch).map { $0.maptoGitRepositoryListResult()}
    }
    
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<GitRepositoryListResult> {
        return self.gitApiService.getRepositoriesByName(nameToSearch: nameToSearch, whereToSearch: whereToSearch).map { $0.maptoGitRepositoryListResult()}
    }
    
    func getRecentlyAccessedRepositories() -> Observable<[GitRepository]> {
        return self.persistentStorageManager.getAllRepositories().map { results in
            Array(results).map {$0.mapToGitRepository()}
        }
    }
    
    func addRecentlyAccessedRepository(repository: GitRepository) {
        self.persistentStorageManager.saveRepository(repository: DatabaseRepository(image: repository.image, url: repository.url, name: repository.name, owner: repository.owner, language: repository.language))
    }
    
}

extension GitApiResult where Value == GitApiSuccessResponse, Error == GitApiError {
    func maptoGitRepositoryListResult() -> GitRepositoryListResult {
        switch self {
        case let .success(gitApiResponse):
            return GitRepositoryListResult.init(value: gitApiResponse.repositoryItems.map{$0.mapToGitRepository()})
        case let .failure(gitApiError):
            return GitRepositoryListResult.init(error: gitApiError.message ?? "Error connecting to the server")
        }
    }
}

extension GitApiResult where Value == [GitApiRepository], Error == GitApiError {
    func maptoGitRepositoryListResult() -> GitRepositoryListResult {
        switch self {
        case let .success(gitApiResponse):
            return GitRepositoryListResult.init(value: gitApiResponse.map{$0.mapToGitRepository()})
        case let .failure(gitApiError):
            return GitRepositoryListResult.init(error: gitApiError.message ?? "Error connecting to the server")
        }
    }
}

extension GitApiRepository {
    
    func mapToGitRepository() -> GitRepository {
        return GitRepository(image: self.owner?.avatarURL, url: self.url, name: self.name, owner: self.owner?.login, language: self.language)
    }
    
}

extension DatabaseRepository {
    
    func mapToGitRepository() -> GitRepository {
        return GitRepository(image: self.image, url: self.url, name: self.name, owner: self.owner, language: self.language)
    }
    
}
