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
        case music
        case video
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
            let viewModel = FeedViewModel()
            let coordinator = FeedFlowCoordinator()
            let vc = FeedViewController(viewModel: viewModel, coordinator: coordinator)
            nc.tabBarItem.title = "Лента"
            nc.tabBarItem.image = UIImage(systemName: "house.fill")
            nc.setViewControllers([vc], animated: false)
        case .profile:
            let viewModel = PostViewModel()
            let coordinator = ProfileFlowCoorinator()
            let vc = ProfileViewController(viewModel: viewModel, coordinator: coordinator)
            nc.tabBarItem.title = "Профиль"
            nc.tabBarItem.image = UIImage(systemName: "person.fill")
            nc.setViewControllers([vc], animated: false)
        case .music:
            let vc = MusicViewController()
            nc.tabBarItem.title = "Музыка"
            nc.tabBarItem.image = UIImage(systemName: "music.note")
            nc.setViewControllers([vc], animated: false)
        case .video:
            let vc = VideoViewController()
            nc.tabBarItem.title = "Видео"
            nc.tabBarItem.image = UIImage(systemName: "film")
            nc.setViewControllers([vc], animated: false)
        }
    }

}
