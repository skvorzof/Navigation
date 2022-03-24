//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by mitr on 19.03.2022.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    private let customView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let titlePost: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private let authorPost: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .systemGray
        $0.text = "Автор: "
        return $0
    }(UILabel())
    
    private let imagePost: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .black
        return $0
    }(UIImageView())
    
    private let descriptionPost: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .systemGray
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fill
        return $0
    }(UIStackView())
    
    private let likesPost: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .black
        $0.text = "👍 "
        return $0
    }(UILabel())
    
    private let viewsPost: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .black
        $0.text = "👀 "
        return $0
    }(UILabel())
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupCell(model: PostModel) {
        titlePost.text = model.title
        authorPost.text? += model.author
        descriptionPost.text = model.description
        imagePost.image = UIImage(named: model.image)
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
