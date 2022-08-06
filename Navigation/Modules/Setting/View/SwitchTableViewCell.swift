//
//  SwitchTableViewCell.swift
//  Navigation
//
//  Created by Dima Skvortsov on 06.08.2022.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    static let identifer = "SwitchTableViewCell"
    
    var switchHandler: ((Bool) -> Void)?

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    private lazy var sortSwitch: UISwitch = {
        let sortSwitch = UISwitch()
        sortSwitch.onTintColor = .systemBlue
        sortSwitch.addTarget(self, action: #selector(didToggleSwitch(_:)), for: .valueChanged)
        sortSwitch.tag = 1
        return sortSwitch
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(sortSwitch)
        accessoryType = .none
        selectionStyle = .none
        accessoryView = sortSwitch
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sortSwitch.sizeToFit()
        label.frame = CGRect(
            x: 16,
            y: 0,
            width: contentView.frame.size.width,
            height: contentView.frame.size.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        sortSwitch.isOn = false
    }

    func congigure(with model: SettingSwitchOption) {
        label.text = model.title
        sortSwitch.isOn = model.isOn
    }
    
    @objc
    func didToggleSwitch(_ sender: UISwitch) {
        if sender.tag == 1 {
            if sender .isOn {
                switchHandler?(true)
            } else {
                switchHandler?(false)
            }
        }
    }
}
