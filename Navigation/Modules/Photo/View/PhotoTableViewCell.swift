//
//  PhotoTableViewCell.swift
//  Navigation
//
//  Created by mitr on 25.03.2022.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    let offset: CGFloat = 12
    let photos = Photo().fetchPhotos()
    
    var delegateNavigation: (() -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
       return collectionView
    }()
        
    private let customView: UIView = {
        let customView = UIView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private let titleView: UILabel = {
        let titleView = UILabel()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = "gallery".localized()
        titleView.textColor = .black
        titleView.font = .systemFont(ofSize: 24, weight: .bold)
        return titleView
    }()
    
     lazy var buttonArrow: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.right", withConfiguration: config), for: .normal)
        return button
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    private func layout() {
        [titleView, buttonArrow].forEach({ stackView.addArrangedSubview($0) })
        [customView, stackView, collectionView].forEach({ contentView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            stackView.topAnchor.constraint(equalTo: customView.topAnchor, constant: offset),
            stackView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -offset),
            stackView.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: offset),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: offset),
            collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -offset),
            collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }  
}




extension PhotoTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photoCell.layer.cornerRadius = 6
        cell.setupCell(model: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
}

extension PhotoTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - offset * 2) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateNavigation?()
    }
}
