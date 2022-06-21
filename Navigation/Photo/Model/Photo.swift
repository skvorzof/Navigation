//
//  Photo.swift
//  Navigation
//
//  Created by mitr on 21.06.2022.
//

import UIKit

final class Photo {
    var photos = [UIImage]()
    
    func fetchPhotos() -> [UIImage] {
        photos.append(UIImage(named: "0")!)
        photos.append(UIImage(named: "1")!)
        photos.append(UIImage(named: "2")!)
        photos.append(UIImage(named: "3")!)
        photos.append(UIImage(named: "4")!)
        photos.append(UIImage(named: "5")!)
        photos.append(UIImage(named: "6")!)
        photos.append(UIImage(named: "7")!)
        photos.append(UIImage(named: "8")!)
        photos.append(UIImage(named: "9")!)
        photos.append(UIImage(named: "10")!)
        return photos
    }
}
