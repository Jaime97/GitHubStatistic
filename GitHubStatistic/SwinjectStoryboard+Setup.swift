//
//  SwinjectStoryboard+Setup.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 28/04/2021.
//

import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.storyboardInitCompleted(RepositorySearchViewController.self) { r, c in
            c.viewModel = r.resolve(RepositorySearchViewModel.self)!
        }
        defaultContainer.register(RepositorySearchViewModel.self) { r in
            RepositorySearchViewModel()
        }
    }
}
