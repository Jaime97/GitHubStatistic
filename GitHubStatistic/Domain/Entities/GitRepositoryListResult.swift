//
//  GitRepositoryListResult.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 10/06/2021.
//

import Foundation

enum GitRepositoryListResult {
    case success([GitRepository])
    case failure(String)

    init(value: [GitRepository]){
        self = .success(value)
    }

    init(error: String){
        self = .failure(error)
    }
    
    func isSuccess() -> Bool {
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    func getSuccessList() throws -> [GitRepository] {
        guard case let .success(repoList) = self else {throw GitRepositoryListError.noListError}
        return repoList
    }
    func getErrorMessage() throws -> String {
        guard case let .failure(errorMessage) = self else {throw GitRepositoryListError.noErrorMessage}
        return errorMessage
    }
}

enum GitRepositoryListError: Error {
    case noListError
    case noErrorMessage
}
