//
//  PhotoModel.swift
//  Navigation
//
//  Created by mitr on 24.03.2022.
//

import UIKit

struct PhotoModel {
    var photo: String
    
    static func makePhotoModel() -> [PhotoModel] {
        var model = [PhotoModel]()
        model.append(PhotoModel(photo: "0"))
        model.append(PhotoModel(photo: "1"))
        model.append(PhotoModel(photo: "2"))
        model.append(PhotoModel(photo: "3"))
        model.append(PhotoModel(photo: "4"))
        model.append(PhotoModel(photo: "5"))
        model.append(PhotoModel(photo: "6"))
        model.append(PhotoModel(photo: "7"))
        model.append(PhotoModel(photo: "8"))
        model.append(PhotoModel(photo: "9"))
        model.append(PhotoModel(photo: "10"))
        model.append(PhotoModel(photo: "0"))
        model.append(PhotoModel(photo: "1"))
        model.append(PhotoModel(photo: "2"))
        model.append(PhotoModel(photo: "3"))
        model.append(PhotoModel(photo: "4"))
        model.append(PhotoModel(photo: "5"))
        model.append(PhotoModel(photo: "6"))
        model.append(PhotoModel(photo: "7"))
        model.append(PhotoModel(photo: "8"))
        model.append(PhotoModel(photo: "9"))
        model.append(PhotoModel(photo: "10"))
        return model
    }
}
