//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by mitr on 09.03.2022.
//

import FirebaseAuth
import SnapKit
import UIKit

class ProfileHeaderView: UIView {

    private var statusText = "Подожтите..."

    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 55
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.text = "МитрофанОглы"
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.text = statusText
        return label
    }()

    private lazy var statusTextField: UITextField = {
        let textField = UITextField()
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
        textField.delegate = self
        return textField
    }()

    private lazy var setStatusButton: CustomButton = {
        let button = CustomButton(title: "Показать статус", titleColor: .white, backColor: .blue)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 12
        button.layer.shadowOffset.width = 3
        button.layer.shadowOffset.height = 3
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        return button
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(animateAvatarOut), for: .touchUpInside)
        return button
    }()

    private var xAvatar = NSLayoutConstraint()
    private var yAvatar = NSLayoutConstraint()
    private var widthAvatar = NSLayoutConstraint()
    private var heightAvatar = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let user = Auth.auth().currentUser
        if let user = user {
            fullNameLabel.text = user.email
        }
        
    #if DEBUG
        backgroundColor = UIColor(red: 243.0/255.0, green: 230.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    #else
        backgroundColor = .systemGray6
    #endif
        
        taps()
        layout()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func statusTextChanged(_ textField: UITextField) {
        if let newStatusText = textField.text {
            if newStatusText != "" {
                statusText = newStatusText
                setStatusButton.setTitle("Установить статус", for: .normal)
            }
        }
    }

    private func taps() {
        setStatusButton.tapAction = { [weak self] in
            self?.statusLabel.text = self?.statusText
            self?.setStatusButton.setTitle("Показать статус", for: .normal)
        }
    }

    private func layout() {
        [fullNameLabel, statusLabel, statusTextField, setStatusButton, overlayView, avatarImageView, closeButton].forEach({ addSubview($0) })

        fullNameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(27)
            $0.leading.equalToSuperview().offset(132)
        }

        statusLabel.snp.makeConstraints {
            $0.top.equalTo(fullNameLabel.snp.bottom).offset(43)
            $0.leading.equalTo(fullNameLabel)
        }

        statusTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.top.equalTo(statusLabel.snp.bottom).offset(7)
            $0.leading.equalTo(statusLabel)
            $0.trailing.equalToSuperview().offset(-16)
        }

        setStatusButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(statusTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        overlayView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
        }

        xAvatar = avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        yAvatar = avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
        widthAvatar = avatarImageView.widthAnchor.constraint(equalToConstant: 110)
        heightAvatar = avatarImageView.heightAnchor.constraint(equalToConstant: 110)

        NSLayoutConstraint.activate([
            xAvatar,
            yAvatar,
            widthAvatar,
            heightAvatar,
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateAvatarIn))
        avatarImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func animateAvatarIn() {
        layoutIfNeeded()

        NSLayoutConstraint.deactivate([xAvatar, yAvatar, widthAvatar, heightAvatar])

        xAvatar = avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        yAvatar = avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        widthAvatar = avatarImageView.widthAnchor.constraint(equalTo: widthAnchor)
        heightAvatar = avatarImageView.heightAnchor.constraint(equalTo: widthAnchor)

        NSLayoutConstraint.activate([xAvatar, yAvatar, widthAvatar, heightAvatar])

        UIView.animate(
            withDuration: 0.5, delay: 0,
            animations: {
                //            self.tabBarController?.tabBar.isHidden = true
                self.overlayView.alpha = 0.70
                self.avatarImageView.layer.borderWidth = 0
                self.avatarImageView.contentMode = .scaleToFill
                self.avatarImageView.layer.cornerRadius = 0
                self.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.3, delay: 0,
                    animations: {
                        self.closeButton.transform = CGAffineTransform(rotationAngle: 165)
                        self.closeButton.alpha = 1
                    })
            })

    }

    @objc private func animateAvatarOut() {
        layoutIfNeeded()

        NSLayoutConstraint.deactivate([xAvatar, yAvatar, widthAvatar, heightAvatar])

        widthAvatar = avatarImageView.widthAnchor.constraint(equalToConstant: 110)
        heightAvatar = avatarImageView.heightAnchor.constraint(equalToConstant: 110)
        yAvatar = avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
        xAvatar = avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)

        NSLayoutConstraint.activate([xAvatar, yAvatar, widthAvatar, heightAvatar])

        UIView.animate(
            withDuration: 0.3, delay: 0,
            animations: {
                self.closeButton.transform = .identity
                self.closeButton.alpha = 0
                self.avatarImageView.layer.borderWidth = 3
                self.avatarImageView.layer.cornerRadius = 55
                self.layoutIfNeeded()
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5, delay: 0,
                    animations: {
                        self.closeButton.alpha = 0
                        self.overlayView.alpha = 0
                        //                self.tabBarController?.tabBar.isHidden = false
                    })
            })

    }
}

extension ProfileHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
