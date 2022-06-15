//
//  AppCoordinator.swift
//  Navigation
//
//  Created by mitr on 14.06.2022.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    
    let window: UIWindow
    
    var childCoordinators = [CoordinatorProtocol]()
    
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    func start() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        childCoordinators = [mainCoordinator]
        window.rootViewController = mainCoordinator.rootViewController
    }
}
