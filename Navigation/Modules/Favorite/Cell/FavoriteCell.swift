//
//  FavoriteCell.swift
//  Navigation
//
//  Created by Dima Skvortsov on 16.08.2022.
//

import UIKit

class FavoriteCell: UITableViewCell {

    private lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var postTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        postImage.image = UIImage(named: "")
        postTitle.text = ""
    }

    func setup(model: Post) {
        postTitle.text = model.title
        postImage.image = UIImage(named: model.image)
    }

    private func setupView() {
        contentView.backgroundColor = .backgroundColor
        addSubview(postImage)
        addSubview(postTitle)

        NSLayoutConstraint.activate([
            postImage.widthAnchor.constraint(equalToConstant: 50),
            postImage.heightAnchor.constraint(equalToConstant: 50),
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            postTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            postTitle.leadingAnchor.constraint(equalTo: postImage.trailingAnchor, constant: 16),
            postTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
