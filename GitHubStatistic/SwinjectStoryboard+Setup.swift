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
        
        // Do not share instances
        defaultContainer.resetObjectScope(.transient)
        
        // MARK: Presentation
        defaultContainer.storyboardInitCompleted(GitRepoSearchViewController.self) { r, c in
            c.viewModel = r.resolve(GitRepoSearchViewModelProtocol.self)!
            c.logger = r.resolve(LoggerProtocol.self, name: LogCategory.presentation.rawValue)!
        }
        defaultContainer.register(GitRepoSearchViewModelProtocol.self) { r in
            GitRepoSearchViewModel(getRecentRepositoriesUseCase: r.resolve(GetRecentRepositoriesUseCaseProtocol.self)!, searchRepositoriesUseCase: r.resolve(SearchRepositoriesUseCaseProtocol.self)!, saveRecentRepositoryUseCase: r.resolve(SaveRecentRepositoryUseCaseProtocol.self)!, logger: r.resolve(LoggerProtocol.self, name: LogCategory.presentation.rawValue)!)
        }
        
        // MARK: Domain
        defaultContainer.register(GetRecentRepositoriesUseCaseProtocol.self) { r in
            GetRecentRepositoriesUseCase(gitRepoSearchRepository: r.resolve(GitRepoSearchRepositoryProtocol.self)!, logger: r.resolve(LoggerProtocol.self, name: LogCategory.domain.rawValue)!)
        }
        defaultContainer.register(SearchRepositoriesUseCaseProtocol.self) { r in
            SearchRepositoriesUseCase(gitRepoSearchRepository: r.resolve(GitRepoSearchRepositoryProtocol.self)!, logger: r.resolve(LoggerProtocol.self, name: LogCategory.domain.rawValue)!)
        }
        defaultContainer.register(SaveRecentRepositoryUseCaseProtocol.self) { r in
            SaveRecentRepositoryUseCase(gitRepoSearchRepository: r.resolve(GitRepoSearchRepositoryProtocol.self)!, logger: r.resolve(LoggerProtocol.self, name: LogCategory.domain.rawValue)!)
        }
        
        // MARK: Data
        defaultContainer.register(GitRepoSearchRepositoryProtocol.self) { r in
            GitRepoSearchRepository(gitApiService: r.resolve(GitApiServiceProtocol.self)!, persistentStorageManager: r.resolve(PersistentStorageManagerProtocol.self)!, logger: r.resolve(LoggerProtocol.self, name: LogCategory.data.rawValue)!)
        }
        defaultContainer.register(GitApiServiceProtocol.self) { r in
            GitApiSevice(logger: r.resolve(LoggerProtocol.self, name: LogCategory.data.rawValue)!)
        }
        defaultContainer.register(PersistentStorageManagerProtocol.self) { r in
            PersistentStorageManager(database: try! Realm(), logger: r.resolve(LoggerProtocol.self, name: LogCategory.data.rawValue)!)
        }
        
        for category in LogCategory.allCases {
            defaultContainer.register(LoggerProtocol.self, name: category.rawValue) { r in
                OSLogger(category: category)
            }
        }
        
    }
}
