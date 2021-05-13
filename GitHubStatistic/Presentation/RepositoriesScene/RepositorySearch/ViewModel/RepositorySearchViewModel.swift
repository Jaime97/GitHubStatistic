//
//  RepositorySearchViewModel.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 06/04/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

protocol RepositorySearchViewModelProtocol {
    
    // MARK: Input
    var searchText : PublishSubject<String?>! { get }
    var isSearchByName : PublishSubject<Bool>! { get }
    var searchViewSwipeGesture : PublishSubject<Bool>! { get }
    var searchButtonTap : PublishSubject<Void>! { get }
    
    // MARK: Output
    var searchViewIsUp : Driver<Bool> { get }
    var previousSearchModels : Driver<[Repository]> { get }
    var newSearchResultModels : Driver<[Repository]> { get }
    var showSearchButton : Driver<Bool> { get }
    var hidePreviousSearchInterface : Driver<Bool> { get }
    var showNewSearchInterface : Driver<Bool> { get }
    var showSearchResults : Driver<Bool> { get }
    
}

class RepositorySearchViewModel: RepositorySearchViewModelProtocol {
    
    // MARK: Input
    let searchText : PublishSubject<String?>! = PublishSubject<String?>()
    let isSearchByName : PublishSubject<Bool>! = PublishSubject<Bool>()
    let searchViewSwipeGesture : PublishSubject<Bool>! = PublishSubject<Bool>()
    let searchButtonTap : PublishSubject<Void>! = PublishSubject<Void>()
    
    // MARK: Output
    let searchViewIsUp : Driver<Bool>
    let previousSearchModels : Driver<[Repository]>
    let newSearchResultModels : Driver<[Repository]>
    let showSearchButton : Driver<Bool>
    let hidePreviousSearchInterface : Driver<Bool>
    let showNewSearchInterface : Driver<Bool>
    let showSearchResults : Driver<Bool>
    
    private let getRecentRepositoriesUseCase : GetRecentRepositoriesUseCaseProtocol
    private let searchRepositoriesUseCase : SearchRepositoriesUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    init(getRecentRepositoriesUseCase : GetRecentRepositoriesUseCaseProtocol, searchRepositoriesUseCase : SearchRepositoriesUseCaseProtocol) {
        self.getRecentRepositoriesUseCase = getRecentRepositoriesUseCase
        self.searchRepositoriesUseCase = searchRepositoriesUseCase
        
        self.searchViewIsUp = self.searchViewSwipeGesture.asDriver(onErrorJustReturn: false).filter{$0}
        self.showSearchButton = self.searchViewSwipeGesture.asDriver(onErrorJustReturn: false).filter{$0}
        
        let searchButtonTappedSubscription = self.searchButtonTap.throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance).share()
        self.hidePreviousSearchInterface = searchButtonTappedSubscription.map{true}.asDriver(onErrorJustReturn: false)
        self.showNewSearchInterface = searchButtonTappedSubscription.delay(.milliseconds(1000), scheduler: MainScheduler.instance).map{true}.asDriver(onErrorJustReturn: false)
        
        self.previousSearchModels = self.getRecentRepositoriesUseCase.execute().asDriver(onErrorJustReturn: [Repository]())
        
        // Start searching repositories when the search text comes in
        let searchResults = self.searchText.unwrap().filter{$0.trimmingCharacters(in: .whitespaces) != ""}.throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withLatestFrom(self.isSearchByName) { searchText, isSearchByName in
                (searchText, isSearchByName)
            }.flatMapLatest { searchText, isSearchByName in
                searchRepositoriesUseCase.execute(nameToSearch: searchText, typeOfSearch: isSearchByName ? .byRepositoryName : .byOwner)
            }.share()
        
        self.newSearchResultModels = searchResults.asDriver(onErrorJustReturn: [Repository]())
        
        self.showSearchResults = searchResults.map{
            !$0.isEmpty
            
        }.filter{
            $0==true
            
        }.asDriver(onErrorJustReturn: false)
        
    }
    
    
}
