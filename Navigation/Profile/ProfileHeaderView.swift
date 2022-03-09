//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by mitr on 09.03.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let profileAvatar: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(named: "avatar.jpg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let profileName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.text = "МитрофанОглы"
        return label
    }()
    
    private let profileStatus: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.text = "Подожтите..."
        return label
    }()
    
    private let statusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать статус", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.layer.shadowOffset.width = 4
        button.layer.shadowOffset.height = 4
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    
    private func setupView() {
        addSubview(profileAvatar)
        addSubview(profileName)
        addSubview(profileStatus)
        addSubview(statusButton)
    }
    
    private func setupConstraint() {
        profileAvatar.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileAvatar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileAvatar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        profileAvatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        profileName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27).isActive = true
        profileName.leftAnchor.constraint(equalTo: profileAvatar.rightAnchor, constant: 20).isActive = true

        profileStatus.bottomAnchor.constraint(equalTo: statusButton.topAnchor, constant: -34).isActive = true
        profileStatus.leftAnchor.constraint(equalTo: profileAvatar.rightAnchor, constant: 20).isActive = true
        
        statusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        statusButton.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: 16).isActive = true
        statusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        statusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
}
