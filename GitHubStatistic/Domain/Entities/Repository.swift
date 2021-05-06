//
//  Repository.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 30/04/2021.
//

import Foundation

class Repository {
    public var image : String
    public var url : String
    public var name : String
    public var owner : String
    public var numberOfCommits: Int
    
    init(image:String, url:String, name:String, owner:String, numberOfCommits:Int) {
        self.image = image
        self.url = url
        self.name = name
        self.owner = owner
        self.numberOfCommits = numberOfCommits
    }
}
