//
//  PhotoCollectionViewCell.swift
//  Navigation
//
//  Created by mitr on 25.03.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    let photoCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupCell(model: UIImage) {
        photoCell.image = model
    }
    
    private func layout() {
        addSubview(photoCell)
        
        NSLayoutConstraint.activate([
            photoCell.topAnchor.constraint(equalTo: topAnchor),
            photoCell.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoCell.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoCell.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
}
