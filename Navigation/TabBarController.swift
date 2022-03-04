//
//  TabBarController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        createTabBarControllers()
    }
    
    func createTabBarControllers() {
        viewControllers = [
            createNavController(for: FeedViewController(),
                                   title: "Лента",
                                   image: UIImage(systemName: "list.dash.header.rectangle")!),
            
            createNavController(for: ProfileViewController(),
                                   title: "Профиль",
                                   image: UIImage(systemName: "person")!)
        ]
    }
    
    func createNavController(for rootViewController: UIViewController,
                             title: String,
                             image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
}
