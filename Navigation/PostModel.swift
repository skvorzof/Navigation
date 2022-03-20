//
//  Post.swift
//  Navigation
//
//  Created by mitr on 08.03.2022.
//

import Foundation
import UIKit

struct PostModel {
    var title: String
    var author: String
    var description: String
    var image: String
    var likes: Int
    var views: Int
    
    static func makePostModel() -> [PostModel] {
        var model = [PostModel]()
        
        model.append(PostModel(title: "One", author: "dmtr", description: "description", image: "logo", likes: 3, views: 3))
        return model
    }
}
