//
//  SettingTableViewCell.swift
//  Navigation
//
//  Created by Dima Skvortsov on 04.08.2022.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    static let identifer = "SettingTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        accessoryType = .none
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(
            x: 16,
            y: 0,
            width: contentView.frame.size.width,
            height: contentView.frame.size.height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func congigure(with model: SettingOption) {
        label.text = model.title
    }
}
