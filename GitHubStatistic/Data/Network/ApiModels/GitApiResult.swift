//
//  GitApiResult.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 09/06/2021.
//

import Foundation

enum GitApiResult<Value, Error> {
    case success(Value)
    case failure(Error)

    init(value: Value){
        self = .success(value)
    }

    init(error: Error){
        self = .failure(error)
    }
}
