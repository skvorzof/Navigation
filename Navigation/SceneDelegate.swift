//
//  SceneDelegate.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let appCoordinator = AppCoordinator(window: window)
            appCoordinator.start()
            self.appCoordinator = appCoordinator
            window.makeKeyAndVisible()
        }
    }
}
