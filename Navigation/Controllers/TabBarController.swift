//
//  TabBarController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class TabBarController: UITabBarController {

    private let feedVC = ModuleFactory(nc: UINavigationController(), flow: .feed)
    private let profileVC = ModuleFactory(nc: UINavigationController(), flow: .profile)
    private let musicVC = ModuleFactory(nc: UINavigationController(), flow: .music)
    private let videoVC = ModuleFactory(nc: UINavigationController(), flow: .video)
    private let documentsVC = ModuleFactory(nc: UINavigationController(), flow: .documents)
    private let settingVC = ModuleFactory(nc: UINavigationController(), flow: .setting)
    private let favoriteVC = ModuleFactory(nc: UINavigationController(), flow: .favorite)
    private let mapVC = ModuleFactory(nc: UINavigationController(), flow: .map)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        setControllers()
    }

    private func setControllers() {
        viewControllers = [
            profileVC.nc,
            feedVC.nc,
            mapVC.nc,
            favoriteVC.nc,
            documentsVC.nc,
            settingVC.nc,
            musicVC.nc,
            videoVC.nc,
        ]
    }
}
