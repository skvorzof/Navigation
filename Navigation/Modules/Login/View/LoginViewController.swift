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
        return textField
    }()

    private lazy var passwordField: CustomField = {
        let textField = CustomField(placeholder: "Ваш пароль")
        textField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        textField.isSecureTextEntry = true
        textField.delegate = self
        return textField
    }()

    private lazy var loginButton: CustomButton = {
        let button = CustomButton(title: "Войти", titleColor: .white, backColor: .blue)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        if button.isSelected || button.isHighlighted {
            button.alpha = 0.8
        } else {
            button.alpha = 1
        }
        button.addTarget(self, action: #selector(pressLoginButton), for: .touchUpInside)
        return button
    }()

    //    private lazy var bruteButton: CustomButton = {
    //        let button = CustomButton(title: "Подобрать пароль", titleColor: UIColor(named: "AccentColor") ?? UIColor.lightGray, backColor: .white)
    //        return button
    //    }()

    //    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    //
    //    private let timerLabel: UILabel = {
    //        let label = UILabel()
    //        label.textAlignment = .center
    //        label.textColor = .systemGray2
    //        return label
    //    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        tap()
        //        counterTimer()

        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.coordinator.showProfile(nc: self.navigationController, coordinator: self.coordinator)
            }
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        nc.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc private func keyboardShow(notification: NSNotification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            //            TODO: Разобраться с высотой
            scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height / 2), animated: true)
        }
    }

    @objc private func keyboardHide() {
        scrollView.setContentOffset(.zero, animated: true)
    }

    @objc private func pressLoginButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isHighlighted = !sender.isHighlighted
    }

    private func tap() {
        loginButton.tapAction = { [emailField, passwordField] in

            guard let email = emailField.text, !email.isEmpty,
                let password = passwordField.text, !password.isEmpty
            else { return }
            CheckerService.shared.completionMessage = { [weak self] message in
                guard let self = self else { return }
                self.present(self.showAllertController(message), animated: true)
            }
            CheckerService.shared.checkCredentials(email: email, password: password)

            //            guard let login = self?.emailField.text,
            //                let password = self?.passwordField.text
            //            else { return }
            //
            //            #if DEBUG
            //
            //                let isLoginOk = true
            //                let userService = TestUserService()
            //
            //            #else
            //
            //                guard let isLoginOk = self?.delegate?.checkerLoginInspector(login: login, password: password) else { return }
            //                let userService = CurrentUserService()
            //
            //            #endif
            //
            //            if isLoginOk {
            //                self?.navigationController?.pushViewController(
            //                    ProfileViewController(postViewModel: PostViewModel(), userService: userService, loginName: login),
            //                    animated: false)
            //            } else {
            //                let alert = UIAlertController(title: "Ошибка", message: "Неправильный логин или пароль", preferredStyle: .alert)
            //                let ok = UIAlertAction(title: "Ok", style: .default)
            //                alert.addAction(ok)
            //                self?.present(alert, animated: true)
            //            }
        }

        //        bruteButton.tapAction = { [crackPass] in
        //            crackPass()
        //        }
    }

    //    private func crackPass() {
    //        let widthPasswordTextField = passwordTextField.frame.width
    //        activityIndicator.center = CGPoint(x: widthPasswordTextField - 20, y: 0)
    //
    //        passwordTextField.leftView?.addSubview(activityIndicator)
    //        activityIndicator.startAnimating()
    //
    //        DispatchQueue.global().async { [loginViewModel, passwordTextField, activityIndicator] in
    //            let pass = loginViewModel.force()
    //
    //            DispatchQueue.main.async {
    //                passwordTextField.isSecureTextEntry = false
    //                activityIndicator.stopAnimating()
    //                passwordTextField.text = pass
    //            }
    //        }
    //    }
    //
    //    private func counterTimer() {
    //        var count = 0
    //        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[timerLabel] timer in
    //            count += 1
    //            timerLabel.text = "Обновление через \(count)"
    //
    //            if count == 10 {
    //                    timer.invalidate()
    //                    timerLabel.text = ""
    //            }
    //        }
    //    }

    private func showAllertController(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Создать", style: .default,
                handler: { _ in
                    guard let email = self.emailField.text, !email.isEmpty,
                        let password = self.passwordField.text, !password.isEmpty
                    else { return }
                    CheckerService.shared.signUp(email: email, password: password)
                }))
        alert.addAction(
            UIAlertAction(
                title: "Отменить", style: .cancel))
        return alert
    }

    private func layout() {
        view.addSubview(scrollView)
        [
            contentView, logo, emailField, passwordField, loginButton,
            //        bruteButton,
            //         timerLabel
        ].forEach({ scrollView.addSubview($0) })

        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        //
        //        bruteButton.snp.makeConstraints {
        //            $0.leading.trailing.equalToSuperview().inset(16)
        //            $0.top.equalTo(loginButton.snp.bottom).offset(16)
        //        }
        //
        //
        //        timerLabel.snp.makeConstraints {
        //            $0.leading.trailing.equalToSuperview().inset(16)
        //            $0.top.equalTo(bruteButton.snp.bottom).offset(16)
        //        }

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
        return true
    }
}
