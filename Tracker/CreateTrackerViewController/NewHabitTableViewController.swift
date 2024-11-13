//
//  NewHabitTableViewController.swift
//  Tracker
//
//  Created by Илья on 26.10.2024.
//

import UIKit

final class NewHabitTableViewController: UITableViewCell {

    static let reuseIdentifier = "NewHabitTableViewCell"
    private let scheduleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let stackView = UIStackView()
    private let chevronImage = UIImageView(image: UIImage(systemName: "chevron.right"))

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        backgroundColor = Colors.textFieldBackground
        stackView.axis = .vertical
        stackView.spacing = 2
        chevronImage.tintColor = .gray
        scheduleLabel.textColor = .gray
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(scheduleLabel)
        stackView.addArrangedSubview(categoryLabel)
        
        contentView.addSubview(stackView)
        contentView.addSubview(chevronImage)
       
        [scheduleLabel, categoryLabel, chevronImage, stackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17)
        ])
    }
    
    func setTitle(_ title: String) {
        categoryLabel.text = title
    }
    
    func setSelectedDays(_ selectedDays: String) {
        scheduleLabel.text = selectedDays
        scheduleLabel.isHidden = selectedDays.isEmpty
    }
    
}
