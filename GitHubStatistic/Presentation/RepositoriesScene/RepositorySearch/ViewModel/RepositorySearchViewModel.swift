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
    let userText : Driver<String>! = nil
    let repositoryText : Driver<String>! = nil
    let searchButton : Driver<Void>! = nil
    let isUserSearch : Driver<Bool>! = nil
    
    
    
    
    
}
