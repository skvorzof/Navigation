//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by mitr on 19.03.2022.
//

import StorageService
import UIKit
import iOSIntPackage

protocol PostTableViewCellDelefate: AnyObject {
    func wasFavoritePost(with title: String)
}

class PostTableViewCell: UITableViewCell {
    struct ViewModel {
        let title: String
        let author: String
        let descriptions: String
        var image: String
        var likes: Int
        var views: Int
        var isFavorite: Bool
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var viewModel: ViewModel?
    weak var delegate: PostTableViewCellDelefate?

    private lazy var customView: UIView = {
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()

    private lazy var titlePost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    private lazy var authorPost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.text = "Автор: "
        return label
    }()

    private lazy var imagePost: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()

    private lazy var descriptionPost: UILabel = {
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
        return stackView
    }()

    private lazy var likesPost: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.text = "👍 "
        return label
    }()

    private lazy var viewsPost: UILabel = {
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
        doubleTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func doubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        customView.addGestureRecognizer(doubleTapGesture)
    }

    @objc
    private func didDoubleTap() {
        guard let viewModel = viewModel else { return }
        
        let request = Favorite.fetchRequest()
        do {
            let result = try context.fetch(request)
            for item in result {
                if item.title == viewModel.title {
                    return
                }
            }
        }catch {
            fatalError("Can`t find to db")
        }

        let favorite = Favorite(context: context)
        favorite.title = viewModel.title
        favorite.author = viewModel.author
        favorite.image = viewModel.image
        favorite.isFavorite = viewModel.isFavorite

        do {
            try context.save()
        } catch {
            fatalError("Can`t save to db")
        }
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
            stackView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -offset),
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension PostTableViewCell {
    func setup(with viewModel: ViewModel) {
        self.viewModel = viewModel
        self.titlePost.text = viewModel.title
        self.authorPost.text = viewModel.author
        self.descriptionPost.text = viewModel.descriptions
        self.imagePost.image = UIImage(named: viewModel.image)
        self.likesPost.text = String(viewModel.likes)
        self.viewsPost.text = String(viewModel.views)
    }
}
