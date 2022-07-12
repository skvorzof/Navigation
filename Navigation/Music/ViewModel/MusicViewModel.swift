//
//  MusicViewModel.swift
//  Navigation
//
//  Created by mitr on 11.07.2022.
//

import Foundation

struct Track {
    let title: String
    let artist: String
    let url: String
}

final class MusicViewModel {
    var tracks: [Track] = [
        Track(title: "Мы ждём перемен.", artist: "Кино", url: "1"),
        Track(title: "Песня без слов.", artist: "Кино", url: "2"),
        Track(title: "Sad but true.", artist: "Metallica", url: "3"),
        Track(title: "The Unforgiven", artist: "Metallica", url: "4"),
        Track(title: "Enter Sndman", artist: "Metallica", url: "5"),
    ]
}
