//
//  MockGetRecentRepositoriesUseCase.swift
//  GitHubStatisticTests
//
//  Created by Jaime Alcántara on 03/09/2021.
//

import Foundation
import RxSwift
@testable import GitHubStatistic

class MockGetRecentRepositoriesUseCase: GetRecentRepositoriesUseCaseProtocol {
    
    var repositoryList:Observable<[GitRepository]>?
    
    func execute() -> Observable<[GitRepository]> {
        return repositoryList ?? Observable<[GitRepository]>.just([GitRepository]())
    }
    
}
