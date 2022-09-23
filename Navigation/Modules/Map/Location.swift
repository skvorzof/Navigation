//
//  Location.swift
//  Navigation
//
//  Created by Dima Skvortsov on 21.09.2022.
//

import CoreLocation

struct Location {
    let name: String
    let latitude: Double
    let longitude: Double
}

extension Location {
    var clLocation: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
