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
    
    
    private var statusText = "Подожтите..."
    
    private let profileAvatar: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
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
    
    private let profileTextChanged: UITextField = {
       let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.shadowColor = UIColor.black.cgColor
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textField
    }()
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if (textField.text?.count)! > 0 {
            statusText = textField.text!
            statusButton.setTitle("Установить статус", for: .normal)
        }
    }
    
    private let statusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать статус", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.layer.shadowOffset.width = 3
        button.layer.shadowOffset.height = 3
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonPressed() {
        profileStatus.text = statusText
        statusButton.setTitle("Показать статус", for: .normal)
    }
    
    
    private func setupView() {
        addSubview(profileAvatar)
        addSubview(profileName)
        addSubview(profileStatus)
        addSubview(statusButton)
        addSubview(profileTextChanged)
    }
    
    private func setupConstraint() {
        profileAvatar.widthAnchor.constraint(equalToConstant: 110).isActive = true
        profileAvatar.heightAnchor.constraint(equalToConstant: 110).isActive = true
        profileAvatar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        profileAvatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        profileName.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27).isActive = true
        profileName.leftAnchor.constraint(equalTo: profileAvatar.rightAnchor, constant: 16).isActive = true

        profileStatus.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 43).isActive = true
        profileStatus.leftAnchor.constraint(equalTo: profileAvatar.rightAnchor, constant: 16).isActive = true
        
        profileTextChanged.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileTextChanged.topAnchor.constraint(equalTo: profileStatus.bottomAnchor, constant: 7).isActive = true
        profileTextChanged.leftAnchor.constraint(equalTo: profileAvatar.rightAnchor, constant: 16).isActive = true
        profileTextChanged.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        statusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        statusButton.topAnchor.constraint(equalTo: profileTextChanged.bottomAnchor, constant: 16).isActive = true
        statusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        statusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
}
