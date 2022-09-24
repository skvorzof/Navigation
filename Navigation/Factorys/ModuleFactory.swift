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
        case documents
        case setting
        case favorite
        case map
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
            nc.tabBarItem.title = "feed".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.image = UIImage(systemName: "house.fill")
            nc.setViewControllers([vc], animated: false)
        case .profile:
            let viewModel = PostViewModel()
            let coordinator = ProfileFlowCoorinator()
            let databaseCoordinator = MigrationService.shared.coreDataCoordinator
            let vc = ProfileViewController(viewModel: viewModel, coordinator: coordinator, databaseCoordinator: databaseCoordinator)
            nc.tabBarItem.title = "profile".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.image = UIImage(systemName: "person.fill")
            nc.setViewControllers([vc], animated: false)
        case .music:
            let vc = MusicViewController()
            vc.title = "music".localized(tableName: "MyLoginFactory")
            nc.navigationBar.prefersLargeTitles = true
            nc.tabBarItem.title = "music".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.image = UIImage(systemName: "music.note")
            nc.setViewControllers([vc], animated: false)
        case .video:
            let vc = VideoViewController()
            vc.title = "video".localized(tableName: "MyLoginFactory")
            nc.navigationBar.prefersLargeTitles = true
            nc.tabBarItem.title = "video".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.image = UIImage(systemName: "film")
            nc.setViewControllers([vc], animated: false)
        case .documents:
            let viewModel = DocumentsViewModel()
            let coordinator = DocumentsFlowCoordinator()
            let vc = DocumentsViewController(viewModel: viewModel, coordinator: coordinator)
            vc.title = "documents".localized(tableName: "MyLoginFactory")
            nc.navigationBar.prefersLargeTitles = true
            nc.tabBarItem.title = "documents".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.image = UIImage(systemName: "folder.fill")
            nc.setViewControllers([vc], animated: false)
        case .setting:
            let vc = SettingViewController()
            vc.title = "settings".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.title = "settings".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.image = UIImage(systemName: "gearshape.fill")
            nc.setViewControllers([vc], animated: false)
        case .favorite:
            let vc = FavoriteViewController()
            vc.title = "favorites".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.title = "favorites".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.image = UIImage(systemName: "star")
            nc.setViewControllers([vc], animated: false)
        case .map:
            let presenter = MapPresenter()
            let vc = MapViewController(presenter: presenter)
            presenter.view = vc
            vc.title = "map".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.title = "map".localized(tableName: "MyLoginFactory")
            nc.tabBarItem.image = UIImage(systemName: "map")
            nc.setViewControllers([vc], animated: false)
        }
    }

}
