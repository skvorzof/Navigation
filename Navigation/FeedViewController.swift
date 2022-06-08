//
//  FeedViewController.swift
//  Navigation
//
//  Created by mitr on 03.03.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let passwordModel = PasswordModel()
        
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textField: CustomTextField = {
        let textField = CustomTextField(placeholder: "Введите пароль")
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.shadowColor = UIColor.black.cgColor
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var checkButton: CustomButton = {
        let button = CustomButton(title: "Проверить", titleColor: .blue, backColor: .white)
        return button
    }()
    
    private lazy var leftButton: CustomButton = {
        let button = CustomButton(title: "Первая", titleColor: .black, backColor: .yellow)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private lazy var rightButton: CustomButton = {
        let button = CustomButton(title: "Вторая", titleColor: .white, backColor: .brown)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        taps()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    
    private func taps() {
        leftButton.tapAction = { [weak self] in
            let infoVC = InfoViewController()
            self?.navigationController?.pushViewController(infoVC, animated: true)
        }
        
        rightButton.tapAction = { [weak self] in
            let infoVC = InfoViewController()
            self?.navigationController?.pushViewController(infoVC, animated: true)
        }
        
        checkButton.tapAction = { [weak self] in
            guard let password = self?.textField.text else { return }
            guard let isCheck = self?.passwordModel.check(password: password) else { return }
            if isCheck {
                self?.textLabel.text = "Верно"
                self?.textLabel.textColor = .systemGreen
            } else {
                self?.textLabel.text = "Неверно"
                self?.textLabel.textColor = .systemRed
            }
        }
    }
    
    
    private func layout() {
        view.addSubview(textLabel)
        view.addSubview(textField)
        view.addSubview(checkButton)
        textLabel.snp.makeConstraints {
            $0.bottom.equalTo(textField.snp.top).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        textField.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)

        }
        checkButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(40)
            $0.top.equalTo(textField.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(rightButton)
        stackView.snp.makeConstraints {
            $0.top.equalTo(checkButton.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
}
