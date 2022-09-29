//
//  SettingChangePasswordViewController.swift
//  Navigation
//
//  Created by Dima Skvortsov on 05.08.2022.
//

import UIKit

class SettingChangePasswordViewController: UIViewController {

    private let viewModel = PasswordViewModel()
    private let coordinator = MainCoordinator()

    private lazy var passwordField: CustomField = {
        let field = CustomField(placeholder: "Введите минимум 4 символа")
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        return field
    }()

    private lazy var button: CustomButton = {
        let button = CustomButton(title: "", titleColor: .white, backColor: .systemBlue)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureViewModel()
        textFieldAction()
        buttonAction()
    }

    private func showToast(message: String) {
        let toastLabel = UILabel(
            frame: CGRect(
                x: 20,
                y: 55,
                width: view.frame.size.width - 40,
                height: 47))
        toastLabel.backgroundColor = .red
        toastLabel.textColor = .white
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.clipsToBounds = true

        view.addSubview(toastLabel)
        UIView.animate(
            withDuration: 2.5, delay: 0.1, options: .curveEaseIn, animations: { toastLabel.alpha = 0.0 }, completion: { _ in toastLabel.removeFromSuperview() })
    }

    private func textFieldAction() {
        passwordField.textFielDidChanged = { [weak self] in
            guard let self = self else { return }
            guard let text = self.passwordField.text else { return }
            self.button.isEnabled = text.count > 3 ? true : false
        }
    }

    private func buttonAction() {
        button.tapAction = { [weak self] in
            guard let self = self else { return }
            guard let text = self.passwordField.text else { return }
            self.viewModel.changePassword(text)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func configureViewModel() {
        viewModel.authState = .modify
        viewModel.sendMessage = { [weak self] message in
            self?.showToast(message: message)
        }
    }

    private func configureUI() {
        view.backgroundColor = .backgroundColor
        
        button.setTitle("Сменить пароль", for: .normal)
        button.setBackgroundColor(.buttonBackground, for: .normal)
        button.setBackgroundColor(.buttonDisabledBackground, for: .disabled)
        button.isEnabled = false

        view.addSubview(passwordField)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            button.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            button.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
