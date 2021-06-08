//
//  GitRepoSearchRepository.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 13/05/2021.
//

import Foundation
import RxSwift

protocol GitRepoSearchRepositoryProtocol {
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<[GitRepository]?>
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<[GitRepository]?>
    func getRecentlyAccessedRepositories() -> Observable<[GitRepository]>
    func addRecentlyAccessedRepository(repository: GitRepository)
    
}

class GitRepoSearchRepository: GitRepoSearchRepositoryProtocol {

    private let gitApiService: GitApiServiceProtocol
    private let persistentStorageManager: PersistentStorageManagerProtocol
    
    init(gitApiService:GitApiServiceProtocol, persistentStorageManager: PersistentStorageManagerProtocol) {
        self.gitApiService = gitApiService
        self.persistentStorageManager = persistentStorageManager
    }
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<[GitRepository]?> {
        return self.gitApiService.getRepositoriesByUser(userToSearch: userToSearch).map { gitApiRepositoryList in
            gitApiRepositoryList?.map {$0.mapToGitRepository()}
        }
    }
    
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<[GitRepository]?> {
        return self.gitApiService.getRepositoriesByName(nameToSearch: nameToSearch, whereToSearch: whereToSearch).map { gitApiRepositoryList in
            gitApiRepositoryList?.map {$0.mapToGitRepository()}
        }
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
