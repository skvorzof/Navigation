//
//  AuthViewController.swift
//  Navigation
//
//  Created by Dima Skvortsov on 08.08.2022.
//

import UIKit

class AuthViewController: UIViewController {

    private let viewModel = AuthViewModel()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 13
        return stackView
    }()

    private lazy var loginField: CustomField = {
        let field = CustomField(placeholder: "Логин")
        field.autocorrectionType = .no
        return field
    }()

    private lazy var passwordField: CustomField = {
        let field = CustomField(placeholder: "Пароль")
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        return field
    }()

    private lazy var button: CustomButton = {
        let button = CustomButton(title: "Войти", titleColor: .white, backColor: .buttonBackground)
        return button
    }()

    private lazy var authorizationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapAuthorizationButton), for: .touchUpInside)
        return button
    }()

    private func showToast(message: String) {
        let toastLabel = UILabel(
            frame: CGRect(
                x: 20,
                y: 100,
                width: view.frame.size.width - 40,
                height: 47))
        toastLabel.backgroundColor = .red
        toastLabel.textColor = .white
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 12
        toastLabel.clipsToBounds = true

        view.addSubview(toastLabel)
        UIView.animate(
            withDuration: 1.5, delay: 0.1, options: .curveEaseIn, animations: { toastLabel.alpha = 0.0 }, completion: { _ in toastLabel.removeFromSuperview() })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        LocalAuthorizationService.shared.getTypeAuthorize { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .faceID:
                self.authorizationButton.setImage(UIImage(systemName: "faceid"), for: .normal)
            case .touchID:
                self.authorizationButton.setImage(UIImage(systemName: "touchid"), for: .normal)
            case .none:
                self.authorizationButton.isEnabled = false
            @unknown default:
                self.authorizationButton.isEnabled = false
            }
        }

        if viewModel.obtainObjects() {
            navigationController?.pushViewController(TabBarController(), animated: false)
        }

        setupView()
        actionsHandlers()
    }

    private func setupView() {
        view.backgroundColor = .backgroundColor

        button.setBackgroundColor(.buttonBackground, for: .normal)
        button.setBackgroundColor(.buttonDisabledBackground, for: .disabled)
        button.isEnabled = false

        view.addSubview(stackView)
        stackView.addArrangedSubview(loginField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(authorizationButton)

        let stackViewConstraints = stackViewConstraints()
        let loginFieldConstraints = loginFieldConstraints()
        let passwordFieldConstraints = passwordFieldConstraints()
        let buttonConstraints = buttonConstraints()
        let authorizationButtonConstraints = authorizationButtonConstraints()

        NSLayoutConstraint.activate(
            stackViewConstraints + loginFieldConstraints + passwordFieldConstraints + buttonConstraints + authorizationButtonConstraints)
    }

    private func loginFieldConstraints() -> [NSLayoutConstraint] {
        let height = loginField.heightAnchor.constraint(equalToConstant: 50)
        return [height]
    }

    private func passwordFieldConstraints() -> [NSLayoutConstraint] {
        let height = passwordField.heightAnchor.constraint(equalToConstant: 50)
        return [height]
    }

    private func buttonConstraints() -> [NSLayoutConstraint] {
        let height = button.heightAnchor.constraint(equalToConstant: 50)
        return [height]
    }

    private func authorizationButtonConstraints() -> [NSLayoutConstraint] {
        let height = authorizationButton.heightAnchor.constraint(equalToConstant: 50)
        return [height]
    }

    private func stackViewConstraints() -> [NSLayoutConstraint] {
        let centerX = stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centerY = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let left = stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        let right = stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        return [centerX, centerY, left, right]
    }

    // MARK: - actionsHandlers
    private func actionsHandlers() {
        loginField.textFielDidChanged = { [weak self] in
            guard let self = self else { return }
            guard let text = self.loginField.text, !text.isEmpty else { return }
            if text.count < 3 {
                self.showToast(message: "Минимум 3 символа")
            } else {
                self.viewModel.login = text
            }
        }

        passwordField.textFielDidChanged = { [weak self] in
            guard let self = self else { return }
            guard let text = self.passwordField.text, !text.isEmpty else { return }
            if text.count < 4 {
                self.showToast(message: "Минимум 4 символа")
                self.button.isEnabled = false
            } else {
                self.viewModel.password = text
                self.button.isEnabled = true
            }
        }

        button.tapAction = { [weak self] in
            guard let self = self else { return }

            if self.viewModel.validatingAuth() {
                self.navigationController?.pushViewController(TabBarController(), animated: true)
            } else {
                self.showToast(message: "Ошибка валидации")
            }
        }
    }

    @objc
    private func didTapAuthorizationButton() {
        LocalAuthorizationService.shared.authorizeIfPossible { result in
            if result {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(TabBarController(), animated: true)
                }
            }
        }
    }
}
