//
//  AppDelegate.swift
//  GitHubStatistic
//
//  Created by user188894 on 05/04/2021.
//

import UIKit
import Swinject
import SwinjectStoryboard

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var container: Container!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        container = Container() { container in
            
            // ViewModels
            container.register(RepositorySearchViewModel.self) { r in
                RepositorySearchViewModel()
            }
            
            // Views
            container.storyboardInitCompleted(UINavigationController.self) { _,_ in }
            container.storyboardInitCompleted(RepositorySearchViewController.self) { r,c in
                c.viewModel = r.resolve(RepositorySearchViewModel.self)!
            }
        }
        
        // Initial Screen
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        window.makeKeyAndVisible()
        self.window = window
        let bundle = Bundle(for: RepositorySearchViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: bundle, container: container)
        window.rootViewController = storyboard.instantiateInitialViewController()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

