//
//  DatabaseRepository.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 31/05/2021.
//

import Foundation
import RealmSwift

class DatabaseRepository : Object {
    @objc dynamic var image : String?
    @objc dynamic var url : String?
    @objc dynamic var name : String?
    @objc dynamic var owner : String?
    
    required convenience init(image:String?, url:String?, name:String?, owner:String?) {
        self.init()
        self.image = image
        self.url = url
        self.name = name
        self.owner = owner
    }
    
}
