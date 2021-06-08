//
//  Repository.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 30/04/2021.
//

import Foundation

struct GitRepository {
    public var image : String?
    public var url : String?
    public var name : String?
    public var owner : String?
    public var language : String?
    
    init(image:String?, url:String?, name:String?, owner:String?, language:String?) {
        self.image = image
        self.url = url
        self.name = name
        self.owner = owner
        self.language = language
    }
}
