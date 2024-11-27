//
//  ScheduleViewCellControllerTableViewCell.swift
//  Tracker
//
//  Created by Илья on 04.11.2024.
//

import UIKit

final class ScheduleViewCell: UITableViewCell {
    let switchView = UISwitch()
    private let titleLabel = UILabel()
    static let reuseIdentifier = "ScheduleTableViewCell"
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupCell() {
        backgroundColor = Colors.textFieldBackground
        switchView.onTintColor = Colors.switchViewColor
        switchView.setOn(false, animated: true)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switchView)
        
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            switchView.heightAnchor.constraint(equalToConstant: 31),
            switchView.widthAnchor.constraint(equalToConstant: 51),
            switchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
     func configureCell(title: String, isSwitchOn: Bool) {
        titleLabel.text = title
        switchView.isOn = isSwitchOn
    }
}
