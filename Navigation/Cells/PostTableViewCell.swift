//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by mitr on 19.03.2022.
//

import UIKit
import iOSIntPackage
import StorageService

class PostTableViewCell: UITableViewCell {
        
    private let customView: UIView = {
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    private let titlePost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private let authorPost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.text = "Автор: "
        return label
    }()
    
    private let imagePost: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let descriptionPost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return  stackView
    }()
    
    private let likesPost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = "👍 "
        return label
    }()
    
    private let viewsPost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = "👀 "
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupCell(model: PostModel) {
        guard let sourceImage = UIImage(named: model.image) else {return}
        let imageProcessor = ImageProcessor()
        let randomFilter = ColorFilter.allCases.randomElement() ?? .posterize
        imageProcessor.processImage(sourceImage: sourceImage, filter: randomFilter) {image in
                imagePost.image = image
            }
        titlePost.text = model.title
        authorPost.text? += model.author
        descriptionPost.text = model.description
        likesPost.text? += String(model.likes)
        viewsPost.text? += String(model.views)
    }
    
    
    private func layout() {
        [likesPost, viewsPost].forEach({ stackView.addArrangedSubview($0) })
        [customView, titlePost, authorPost, imagePost, descriptionPost, stackView].forEach({
            contentView.addSubview($0)
        })
        
        let offset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titlePost.topAnchor.constraint(equalTo: customView.topAnchor, constant: offset),
            titlePost.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: offset),
            titlePost.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -offset),
            
            authorPost.topAnchor.constraint(equalTo: titlePost.bottomAnchor, constant: offset / 3),
            authorPost.leadingAnchor.constraint(equalTo: titlePost.leadingAnchor),
            authorPost.trailingAnchor.constraint(equalTo: titlePost.trailingAnchor),
            
            imagePost.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imagePost.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            imagePost.topAnchor.constraint(equalTo: authorPost.bottomAnchor, constant: offset),
            imagePost.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            imagePost.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            
            descriptionPost.topAnchor.constraint(equalTo: imagePost.bottomAnchor, constant: offset),
            descriptionPost.leadingAnchor.constraint(equalTo: authorPost.leadingAnchor),
            descriptionPost.trailingAnchor.constraint(equalTo: authorPost.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: descriptionPost.bottomAnchor, constant: offset),
            stackView.leadingAnchor.constraint(equalTo: descriptionPost.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: descriptionPost.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -offset)
        ])
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
