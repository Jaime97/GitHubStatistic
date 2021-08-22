//
//  GitRepoSearchViewModel.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 06/04/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol GitRepoSearchViewModelProtocol {
    
    // MARK: Input
    var searchText : PublishSubject<String?>! { get }
    var isSearchByName : PublishSubject<Bool>! { get }
    var searchViewSwipeGesture : PublishSubject<Bool>! { get }
    var searchButtonTap : PublishSubject<Void>! { get }
    var searchResultSelected : PublishSubject<GitRepository>! { get }
    
    // MARK: Output
    var searchViewIsUp : Driver<Bool> { get }
    var previousSearchesModels : Driver<[GitRepository]> { get }
    var showPreviousSearches : Driver<Bool> { get }
    var newSearchResultModels : Driver<[GitRepository]> { get }
    var showSearchButton : Driver<Bool> { get }
    var hidePreviousSearchInterface : Driver<Bool> { get }
    var showNewSearchInterface : Driver<Bool> { get }
    var showSearchResults : Driver<Bool> { get }
    var searchResultError : Driver<String> { get }
    
}

class GitRepoSearchViewModel: GitRepoSearchViewModelProtocol {
    
    // MARK: Input
    let searchText : PublishSubject<String?>! = PublishSubject<String?>()
    let isSearchByName : PublishSubject<Bool>! = PublishSubject<Bool>()
    let searchViewSwipeGesture : PublishSubject<Bool>! = PublishSubject<Bool>()
    let searchButtonTap : PublishSubject<Void>! = PublishSubject<Void>()
    let searchResultSelected : PublishSubject<GitRepository>! = PublishSubject<GitRepository>()
    
    // MARK: Output
    let searchViewIsUp : Driver<Bool>
    let previousSearchesModels : Driver<[GitRepository]>
    let showPreviousSearches : Driver<Bool>
    let newSearchResultModels : Driver<[GitRepository]>
    let showSearchButton : Driver<Bool>
    let hidePreviousSearchInterface : Driver<Bool>
    let showNewSearchInterface : Driver<Bool>
    let showSearchResults : Driver<Bool>
    let searchResultError : Driver<String>
    
    private let getRecentRepositoriesUseCase : GetRecentRepositoriesUseCaseProtocol
    private let searchRepositoriesUseCase : SearchRepositoriesUseCaseProtocol
    private let saveRecentRepositoryUseCase : SaveRecentRepositoryUseCaseProtocol
    private let disposeBag = DisposeBag()
    private let logger : LoggerProtocol
    
    init(getRecentRepositoriesUseCase : GetRecentRepositoriesUseCaseProtocol, searchRepositoriesUseCase : SearchRepositoriesUseCaseProtocol, saveRecentRepositoryUseCase: SaveRecentRepositoryUseCaseProtocol, logger: LoggerProtocol) {
        self.logger = logger
        self.getRecentRepositoriesUseCase = getRecentRepositoriesUseCase
        self.searchRepositoriesUseCase = searchRepositoriesUseCase
        self.saveRecentRepositoryUseCase = saveRecentRepositoryUseCase
        
        self.searchViewIsUp = self.searchViewSwipeGesture.asDriver(onErrorJustReturn: false).filter{$0}
        self.showSearchButton = self.searchViewSwipeGesture.asDriver(onErrorJustReturn: false).filter{$0}
        
        let searchButtonTappedSubscription = self.searchButtonTap.throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance).share()
        self.hidePreviousSearchInterface = searchButtonTappedSubscription.map{true}.asDriver(onErrorJustReturn: false)
        self.showNewSearchInterface = searchButtonTappedSubscription.delay(.milliseconds(1000), scheduler: MainScheduler.instance).map{true}.asDriver(onErrorJustReturn: false)
        
        let previousSearchesResults = self.getRecentRepositoriesUseCase.execute().share(replay: 1, scope: .forever)
        
        self.previousSearchesModels = previousSearchesResults.asDriver(onErrorJustReturn: [GitRepository]())
        self.showPreviousSearches = previousSearchesResults.map{!$0.isEmpty}.asDriver(onErrorJustReturn: false)
        
        // Start searching repositories when the search text comes in
        let searchResults = self.searchText.unwrap().filter{$0.trimmingCharacters(in: .whitespaces) != ""}.throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(self.isSearchByName) { searchText, isSearchByName in
                (searchText, isSearchByName)
            }.flatMapLatest { searchText, isSearchByName in
                searchRepositoriesUseCase.execute(nameToSearch: searchText, typeOfSearch: isSearchByName ? .byRepositoryName : .byOwner)
            }.share()
        
        self.newSearchResultModels = searchResults.delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .filter{$0.isSuccess()}
            .map{try! $0.getSuccessList()}
            .asDriver(onErrorJustReturn: [GitRepository]())
        
        self.searchResultError = searchResults.delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .filter{!$0.isSuccess()}
            .map{
                let errorMessage = try! $0.getErrorMessage()
                return NSLocalizedString("default_server_list_error", comment: "") + " " + NSLocalizedString("server_message", comment: "") + " " + errorMessage
            }.asDriver(onErrorJustReturn: NSLocalizedString("default_server_list_error", comment: ""))
        
        self.showSearchResults = searchResults.map{
            switch $0 {
            case let .success(repoList):
                return !repoList.isEmpty
            case .failure(_):
                return false
            }
        }.asDriver(onErrorJustReturn: false)
        
        self.searchResultSelected.subscribe{self.saveRecentRepositoryUseCase.execute(recentRepository: $0)}
            .disposed(by: self.disposeBag)
    }
    
    
}
