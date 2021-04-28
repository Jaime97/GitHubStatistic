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
    
    // MARK: Input
    let searchText : Driver<String>! = nil
    let searchButton : Driver<Void>! = nil
    let isUserSearch : Driver<Bool>! = nil
    let searchViewGesture : PublishSubject<Bool>! = PublishSubject<Bool>()
    
    // MARK: Output
    let searchViewIsUp : Driver<Bool>!
    
    override init() {
        self.searchViewIsUp = self.searchViewGesture.asDriver(onErrorJustReturn: false)
    }
    
    
}
