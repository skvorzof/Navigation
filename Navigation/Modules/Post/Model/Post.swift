//
//  Post.swift
//  Navigation
//
//  Created by mitr on 08.03.2022.
//

import UIKit

public struct Post: Equatable {
    public var title: String
    public var author: String
    public var descriptions: String
    public var image: String
    public var likes: Int
    public var views: Int
    public var isFavorite: Bool

    var keyedValues: [String: Any] {
        return [
            "title": self.title,
            "author": self.author,
            "descriptions": self.descriptions,
            "image": self.image,
            "likes": self.likes,
            "views": self.likes,
            "isFavorite": self.isFavorite
        ]
    }
    
    init(title: String, author: String, descriptions: String, image: String, likes: Int, views: Int, isFavorite: Bool) {
        self.title = title
        self.author = author
        self.descriptions = descriptions
        self.image = image
        self.likes = likes
        self.views = views
        self.isFavorite = isFavorite
    }

    init(favorite: Favorite) {
        self.title = favorite.title ?? ""
        self.author = favorite.author ?? ""
        self.descriptions = favorite.description
        self.image = favorite.image ?? ""
        self.likes = Int(favorite.likes)
        self.views = Int(favorite.views)
        self.isFavorite = favorite.isFavorite
    }
}
