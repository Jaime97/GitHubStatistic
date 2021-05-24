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
    
}

class GitRepoSearchRepository: GitRepoSearchRepositoryProtocol {
    
    private let gitApiService: GitApiServiceProtocol
    
    init(gitApiService:GitApiServiceProtocol) {
        self.gitApiService = gitApiService
    }
    
    func getRepositoriesByUser(userToSearch: String) -> Observable<[GitRepository]?> {
        return self.gitApiService.getRepositoriesByUser(userToSearch: userToSearch).map { gitApiRepositoryList in
            gitApiRepositoryList?.map { $0.mapToGitRepository()}
        }
    }
    
    func getRepositoriesByName(nameToSearch: String, whereToSearch: String) -> Observable<[GitRepository]?> {
        return self.gitApiService.getRepositoriesByName(nameToSearch: nameToSearch, whereToSearch: whereToSearch).map { gitApiRepositoryList in
            gitApiRepositoryList?.map { $0.mapToGitRepository()}
        }
    }
    
}

extension GitApiRepository {
    
    func mapToGitRepository() -> GitRepository {
        return GitRepository(image: self.owner?.avatarURL, url: self.url, name: self.name, owner: self.owner?.login, numberOfCommits: 0)
    }
    
}
