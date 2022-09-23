//
//  MapPresenter.swift
//  Navigation
//
//  Created by Dima Skvortsov on 21.09.2022.
//

import Foundation

protocol MapPresenterProtocol: AnyObject {
    func requestBranchLocations()
}

final class MapPresenter: MapPresenterProtocol {
    weak var view: MapViewProtocol?

    private let locations: [Location] = [
        Location(name: "Сюда иди", latitude: 55.757301, longitude: 37.632077)
    ]

    func requestBranchLocations() {
        view?.displayBranchLocations(locations)
    }
}
