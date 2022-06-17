//
//  MyLoginFactory.swift
//  Navigation
//
//  Created by mitr on 31.05.2022.
//

import UIKit

final class ModuleFactory {
    
    enum Flow {
        case feed
        case profile
    }
    
    
    let nc: UINavigationController
    let flow: Flow
    
    
    init(nc: UINavigationController, flow: Flow) {
        self.nc = nc
        self.flow = flow
        
        startModule()
    }
    
    
    func startModule() {
        switch flow {
        case .feed:
            let coordinator = FeedCoordinator()
            let vc = coordinator.showFeed(coordinator: coordinator)
            nc.tabBarItem.title = "Лента"
            nc.tabBarItem.image = UIImage(systemName: "house.fill")
            nc.setViewControllers([vc], animated: false)
        case .profile:
            let vc = LoginViewController()
            nc.tabBarItem.title = "Профиль"
            nc.tabBarItem.image = UIImage(systemName: "person.fill")
            nc.setViewControllers([vc], animated: false)
        }
    }
    
}
