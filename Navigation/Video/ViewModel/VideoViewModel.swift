//
//  VideoViewModel.swift
//  Navigation
//
//  Created by mitr on 11.07.2022.
//

import Foundation

struct Video {
    let title: String
    let url: String
}

final class VideoViewModel {
    var urls: [Video] = [
        Video(title: "Flying Failures", url: "Je8wxnoEkug"),
        Video(title: "CAR DRIVING IN NIGHT CITY", url: "KWnil5oy-Ic"),
        Video(title: "Background Nature Video", url: "Faow3SKIzq0"),
        Video(title: "Land Speed Record - Progression", url: "gqTd3rgpok4"),
    ]
}
