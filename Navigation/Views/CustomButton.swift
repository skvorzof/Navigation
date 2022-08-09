//
//  CustomButton.swift
//  Navigation
//
//  Created by mitr on 08.06.2022.
//

import UIKit

class CustomButton: UIButton {
    
    enum ButtonState {
        case normal
        case disabled
    }
    
    private var disabledBackgroundColor: UIColor?
    private var defaultBackgroundColor: UIColor? {
        didSet {
            backgroundColor = defaultBackgroundColor
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                if let color = defaultBackgroundColor {
                    self.backgroundColor = color
                }
            } else {
                if let color = disabledBackgroundColor {
                    self.backgroundColor = color
                }
            }
        }
    }
    
    let title: String
    let titleColor: UIColor
    let backColor: UIColor

    var tapAction: (() -> Void)?
    
    init(title: String, titleColor: UIColor, backColor: UIColor) {
        self.title = title
        self.titleColor = titleColor
        self.backColor = backColor
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backColor
        self.layer.cornerRadius = 10
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        tapAction?()
    }
    
    func setBackgroundColor(_ color: UIColor?, for state: ButtonState) {
        switch state {
        case .disabled:
            disabledBackgroundColor = color
        case .normal:
            defaultBackgroundColor = color
        }
    }
}
