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
        
    #if DEBUG
        backgroundColor = UIColor(red: 243.0/255.0, green: 230.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    #else
        backgroundColor = .systemGray6
    #endif
        
    layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
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
    
    private lazy var setStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать статус", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 12
        button.layer.shadowOffset.width = 3
        button.layer.shadowOffset.height = 3
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.6
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if let newStatusText = textField.text {
            if newStatusText != "" {
                statusText = newStatusText
                setStatusButton.setTitle("Установить статус", for: .normal)
            }
        }
    }
    
    @objc private func buttonPressed() {
        statusLabel.text = statusText
        setStatusButton.setTitle("Показать статус", for: .normal)
    }
    
    

    private func layout() {
        [fullNameLabel, statusLabel, statusTextField, setStatusButton].forEach({addSubview($0)})
        
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
    }
}



extension ProfileHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
}
