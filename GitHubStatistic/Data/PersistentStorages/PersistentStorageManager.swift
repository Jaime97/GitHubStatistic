//
//  PersistentStorageManager.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 31/05/2021.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

protocol PersistentStorageManagerProtocol {
    
    func getAllRepositories() -> Observable<Results<DatabaseRepository>>
    
    func saveRepository(repository:DatabaseRepository)

}

class PersistentStorageManager : PersistentStorageManagerProtocol {
    
    private let database : Realm
    private let logger : LoggerProtocol
    
    init(database: Realm, logger: LoggerProtocol) {
        self.database = database
        self.logger = logger
    }
    
    func getAllRepositories() -> Observable<Results<DatabaseRepository>> {
        let repositories = self.database.objects(DatabaseRepository.self)
        return Observable.collection(from: repositories)
    }
    
    func saveRepository(repository:DatabaseRepository) {
        try? database.write {
            database.add(repository)
        }
    }
    
}
