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
    let searchButton : Driver<Void>! = nil
    let isUserSearch : Driver<Bool>! = nil
    let searchViewGesture : PublishSubject<Bool>! = PublishSubject<Bool>()
    
    // MARK: Output
    let searchViewIsUp : Driver<Bool>!
    let previousSearchCells: Driver<[Repository]>
    
    init(getRecentRepositoriesUseCase : GetRecentRepositoriesUseCase) {
        self.getRecentRepositoriesUseCase = getRecentRepositoriesUseCase
        self.searchViewIsUp = self.searchViewGesture.asDriver(onErrorJustReturn: false)
        self.previousSearchCells = self.getRecentRepositoriesUseCase.execute().asDriver(onErrorJustReturn: [Repository]())
    }
    
    
}
