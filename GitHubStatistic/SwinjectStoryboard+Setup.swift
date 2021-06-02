//
//  SwinjectStoryboard+Setup.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 28/04/2021.
//

import SwinjectStoryboard
import RealmSwift

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.storyboardInitCompleted(GitRepoSearchViewController.self) { r, c in
            c.viewModel = r.resolve(GitRepoSearchViewModelProtocol.self)!
        }
        defaultContainer.register(GitRepoSearchViewModelProtocol.self) { r in
            GitRepoSearchViewModel(getRecentRepositoriesUseCase: r.resolve(GetRecentRepositoriesUseCaseProtocol.self)!, searchRepositoriesUseCase: r.resolve(SearchRepositoriesUseCaseProtocol.self)!, saveRecentRepositoryUseCase: r.resolve(SaveRecentRepositoryUseCaseProtocol.self)!)
        }
        defaultContainer.register(GetRecentRepositoriesUseCaseProtocol.self) { r in
            GetRecentRepositoriesUseCase(gitRepoSearchRepository: r.resolve(GitRepoSearchRepositoryProtocol.self)!)
        }
        defaultContainer.register(SearchRepositoriesUseCaseProtocol.self) { r in
            SearchRepositoriesUseCase(gitRepoSearchRepository: r.resolve(GitRepoSearchRepositoryProtocol.self)!)
        }
        defaultContainer.register(SaveRecentRepositoryUseCaseProtocol.self) { r in
            SaveRecentRepositoryUseCase(gitRepoSearchRepository: r.resolve(GitRepoSearchRepositoryProtocol.self)!)
        }
        defaultContainer.register(GitRepoSearchRepositoryProtocol.self) { r in
            GitRepoSearchRepository(gitApiService: r.resolve(GitApiServiceProtocol.self)!, persistentStorageManager: r.resolve(PersistentStorageManagerProtocol.self)!)
        }
        defaultContainer.register(GitApiServiceProtocol.self) { r in
            GitApiSevice()
        }
        defaultContainer.register(PersistentStorageManagerProtocol.self) { r in
            PersistentStorageManager(database: try! Realm())
        }
    }
}
