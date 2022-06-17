//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by mitr on 16.06.2022.
//

import UIKit

final class FeedCoordinator {

    func showFeed(coordinator: FeedCoordinator) -> UIViewController {
        let viewModel = FeedViewModel()
        let vc = FeedViewController(viewModel: viewModel, coordinator: coordinator)
        return vc
    }
}
