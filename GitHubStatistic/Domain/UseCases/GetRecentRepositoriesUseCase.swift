//
//  GetRecentRepositoriesUseCase.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 30/04/2021.
//

import Foundation
import RxSwift

class GetRecentRepositoriesUseCase {
    
    public func execute() -> Single<[Repository]> {
        let repository: Repository = Repository(image: "", url: "", name: "Example 1", numberOfCommits: 24)
        let repository2: Repository = Repository(image: "", url: "", name: "Example 2", numberOfCommits: 35)
        let repository3: Repository = Repository(image: "", url: "", name: "Very long name example", numberOfCommits: 2)
        let repository4: Repository = Repository(image: "", url: "", name: "Short", numberOfCommits: 123)
        let repository5: Repository = Repository(image: "", url: "", name: "Example 5", numberOfCommits: 1240)
        return Observable.just([repository, repository2, repository3, repository4, repository5]).asSingle()
    }
    
}
