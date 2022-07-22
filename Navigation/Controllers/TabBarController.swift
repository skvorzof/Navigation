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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        setControllers()
    }
    
    private func setControllers() {
        viewControllers = [
            profileVC.nc,
            feedVC.nc,
            musicVC.nc,
            videoVC.nc
        ]
    }
}
