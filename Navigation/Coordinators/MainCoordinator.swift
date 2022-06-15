//
//  MainCoordinator.swift
//  Navigation
//
//  Created by mitr on 15.06.2022.
//

import UIKit

final class MainCoordinator: CoordinatorProtocol {
    
    var rootViewController = UITabBarController()
    
    var childCoordinators = [CoordinatorProtocol]()
    
    
    init() {
        self.rootViewController = UITabBarController()
        rootViewController.tabBar.backgroundColor = .white
    }
    
    
    func start() {
        let profileCoordinator = ProfileTabCoordinator()
        profileCoordinator.start()
        self.childCoordinators.append(profileCoordinator)
        let firstViewController = profileCoordinator.rootViewController
        setup(vc: firstViewController, title: "Профиль", imageName: "person.fill", tag: 0)
        
        let feedCoordinator = FeedTabCoordinator()
        feedCoordinator.start()
        self.childCoordinators.append(feedCoordinator)
        let secondViewController = feedCoordinator.rootViewController
        setup(vc: secondViewController, title: "Лента", imageName: "house.fill", tag: 1)
        
        
        self.rootViewController.viewControllers = [firstViewController, secondViewController]
        self.rootViewController.selectedIndex = 1
    }
    
    
    private func setup(
        vc: UIViewController,
        title: String,
        imageName: String,
        tag: Int) {
            let image = UIImage(systemName: imageName)
            let tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
            vc.tabBarItem = tabBarItem
        }
}
