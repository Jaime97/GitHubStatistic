//
//  SearchRepositoryUseCase.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 06/05/2021.
//

import Foundation
import RxSwift

enum TypeOfSearch {
    case byRepositoryName
    case byOwner
}

protocol SearchRepositoriesUseCaseProtocol {
    func execute(nameToSearch:String, typeOfSearch:TypeOfSearch) -> Observable<[Repository]>
}

class SearchRepositoriesUseCase : SearchRepositoriesUseCaseProtocol {
    public func execute(nameToSearch:String, typeOfSearch:TypeOfSearch) -> Observable<[Repository]> {
        let repository: Repository = Repository(image: "", url: "", name: "Example 1", owner: "user1", numberOfCommits: 24)
        let repository2: Repository = Repository(image: "", url: "", name: "Example 2", owner: "Very long user name", numberOfCommits: 35)
        let repository3: Repository = Repository(image: "", url: "", name: "Very long name example", owner: "Short", numberOfCommits: 2)
        let repository4: Repository = Repository(image: "", url: "", name: "Short", owner: "user4", numberOfCommits: 123)
        let repository5: Repository = Repository(image: "", url: "", name: "Example 5", owner: "User 5", numberOfCommits: 1240)
        return Observable.just([repository, repository2, repository3, repository4, repository5])
    }
}
