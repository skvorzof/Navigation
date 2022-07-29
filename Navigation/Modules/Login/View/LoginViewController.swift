//
//  LogInViewController.swift
//  Navigation
//
//  Created by mitr on 19.03.2022.
//

import FirebaseAuth
import SnapKit
import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func checkerLoginInspector(login: String, password: String) -> Bool
}

// MARK: - LoginViewController
class LoginViewController: UIViewController {

    private let loginViewModel = LoginViewModel()
    private let coordinator = ProfileFlowCoorinator()

    var delegate: LoginViewControllerDelegate?

    private let nc = NotificationCenter.default

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        return imageView
    }()

    private lazy var emailField: CustomField = {
        let textField = CustomField(placeholder: "Ваша почта")
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChenged), for: .editingChanged)
        return textField
    }()

    private lazy var passwordField: CustomField = {
        let textField = CustomField(placeholder: "Ваш пароль")
        textField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        textField.isSecureTextEntry = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChenged), for: .editingChanged)
        return textField
    }()

    private lazy var loginButton: CustomButton = {
        let button = CustomButton(title: "Вход / Регистрация", titleColor: .white, backColor: Color.accentColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        if button.isSelected || button.isHighlighted {
            button.alpha = 0.8
        } else {
            button.alpha = 1
        }
        button.isEnabled = false
        button.addTarget(self, action: #selector(pressLoginButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        layout()
        tap()
        loginButton.setBackgroundColor(Color.accentColor, for: .normal)
        loginButton.setBackgroundColor(Color.disableColor, for: .disabled)
        loginButton.isEnabled = false

        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if user != nil {
                self.coordinator.showProfile(nc: self.navigationController, coordinator: self.coordinator)
            }
        }

        CheckerService.shared.completionMessage = { [weak self] message in
            guard let self = self else { return }
            self.present(self.showAllertController(message), animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

        nc.addObserver(
            self,
            selector: #selector(keyboardShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        nc.addObserver(
            self,
            selector: #selector(keyboardHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        nc.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc
    private func keyboardShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            //            TODO: Разобраться с высотой
            scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height / 2), animated: true)
        }
    }

    @objc
    private func keyboardHide() {
        scrollView.setContentOffset(.zero, animated: true)
    }

    @objc
    private func pressLoginButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isHighlighted = !sender.isHighlighted
    }

    @objc
    private func textFieldDidChenged() {
        if emailField.text?.isEmpty == false && passwordField.text!.count >= 6 {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }

    private func tap() {
        loginButton.tapAction = { [emailField, passwordField] in

            guard let email = emailField.text, !email.isEmpty,
                let password = passwordField.text, !password.isEmpty
            else { return }

            CheckerService.shared.checkCredentials(email: email, password: password)
        }
    }

    private func showAllertController(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Ок", style: .cancel))
        return alert
    }

    private func layout() {
        view.addSubview(scrollView)
        [contentView, logo, emailField, passwordField, loginButton].forEach({ scrollView.addSubview($0) })

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            logo.widthAnchor.constraint(equalToConstant: 100),
            logo.heightAnchor.constraint(equalToConstant: 100),
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            emailField.heightAnchor.constraint(equalToConstant: 50),
            emailField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 120),
            emailField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            passwordField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),

            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            loginButton.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
        ])
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        textField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
}
