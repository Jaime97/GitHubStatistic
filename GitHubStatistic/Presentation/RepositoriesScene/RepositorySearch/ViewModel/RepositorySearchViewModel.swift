//
//  RepositorySearchViewModel.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 06/04/2021.
//

import Foundation
import RxSwift
import RxCocoa


class RepositorySearchViewModel : BaseViewModel {
    
    let getRecentRepositoriesUseCase : GetRecentRepositoriesUseCase
    
    // MARK: Input
    let searchText : Driver<String>! = nil
    let isUserSearch : Driver<Bool>! = nil
    let searchViewSwipeGesture : PublishSubject<Bool>! = PublishSubject<Bool>()
    let searchButtonTap : PublishSubject<Void>! = PublishSubject<Void>()
    
    // MARK: Output
    let searchViewIsUp : Driver<Bool>
    let previousSearchCells : Driver<[Repository]>
    let showSearchButton : Driver<Bool>
    let hidePreviousSearchInterface : Driver<Bool>
    let showNewSearchInterface : Driver<Bool>
    
    init(getRecentRepositoriesUseCase : GetRecentRepositoriesUseCase) {
        self.getRecentRepositoriesUseCase = getRecentRepositoriesUseCase
        self.searchViewIsUp = self.searchViewSwipeGesture.asDriver(onErrorJustReturn: false).filter{$0}
        self.previousSearchCells = self.getRecentRepositoriesUseCase.execute().asDriver(onErrorJustReturn: [Repository]())
        self.showSearchButton = self.searchViewSwipeGesture.asDriver(onErrorJustReturn: false).filter{$0}
        
        let searchButtonTappedSubscription = self.searchButtonTap.throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance).share()
        self.hidePreviousSearchInterface = searchButtonTappedSubscription.map{true}.asDriver(onErrorJustReturn: false)
        self.showNewSearchInterface = searchButtonTappedSubscription.delay(.milliseconds(300), scheduler: MainScheduler.instance).map{true}.asDriver(onErrorJustReturn: false)
    }
    
    
}
