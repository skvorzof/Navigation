//
//  CustomTextField.swift
//  Navigation
//
//  Created by mitr on 19.03.2022.
//

import UIKit

class CustomField: UITextField {

    var textFielDidChanged: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    init(placeholder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .black
        font = UIFont.systemFont(ofSize: 16, weight: .regular)
        autocapitalizationType = .none
        tintColor = UIColor(named: "AccentColor")
        backgroundColor = .systemGray6
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 10
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 2))
        self.leftView = leftView
        leftViewMode = .always
        self.placeholder = placeholder
        self.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func textFieldChanged() {
        textFielDidChanged?()
    }
}
