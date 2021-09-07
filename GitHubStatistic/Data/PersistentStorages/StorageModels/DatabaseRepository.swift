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
    @objc dynamic var language : String?
    @objc dynamic var compoundKey : String?
    
    required convenience init(image:String?, url:String?, name:String?, owner:String?, language:String?) {
        self.init()
        self.image = image
        self.url = url
        self.name = name
        self.owner = owner
        self.language = language
        self.compoundKey = (self.owner ?? "") + "-" + (self.name ?? "")
    }
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
}
