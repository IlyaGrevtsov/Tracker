//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Илья on 28.10.2024.
//

import UIKit

protocol TrackerViewCellDelegate: AnyObject {
    func record(_ sender: Bool, _ cell: TrackerCollectionViewCell)
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}


final class TrackerCollectionViewCell: UICollectionViewCell {
    //MARK: - Constant
    static let cellIdentifier: String = "TrakerVcCell"
    let labelEmoji =  UILabel()
    let completionButton = UIButton()
    let nameLabel = UILabel()
    let colorOfCellView = UIView()
    let counterDaysLabel = UILabel()
    
    private var trackersIsCompleted = false
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    weak var delegate: TrackerViewCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        setupEmojiLabel()
        setupNameLabel()
        setupCounterDaysLabel()
        setupCompletionButton()
        constraint()
    }
    
    private func setupEmojiLabel() {
        labelEmoji.font = UIFont.systemFont(ofSize: 12)
        labelEmoji.backgroundColor = .white.withAlphaComponent(0.3)
        labelEmoji.layer.cornerRadius = 12
        labelEmoji.layer.masksToBounds = true
        labelEmoji.textAlignment = .center
    }
    private func setupNameLabel() {
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byWordWrapping
    }
    private func setupCounterDaysLabel() {
        counterDaysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        counterDaysLabel.lineBreakMode = .byWordWrapping
    }
    private func setupCompletionButton() {
        completionButton.layer.cornerRadius = 16
        completionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completionButton.tintColor = .white
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
    }
    
    func configure (
        with tracker: Tracker,
        trackersIsCompleted: Bool,
        completedDays: Int,
        indexPath: IndexPath
        
    ) {
        self.trackersIsCompleted = trackersIsCompleted
        self.trackerId = tracker.id
        self.indexPath = indexPath
        
        nameLabel.text = tracker.name
        colorOfCellView.backgroundColor = tracker.color
        completionButton.backgroundColor = tracker.color
        labelEmoji.text = tracker.emoji
        
        let imageName = trackersIsCompleted ? "checkmark" : "plus"
        if let image = UIImage(systemName: imageName) {
            completionButton.setImage(image, for: .normal)
        }
        counterDaysLabel.text = counterofCompletedDays(completedDays)
        dayForCompleted(with: tracker)
    }
    
    private func counterofCompletedDays(_ count: Int) -> String {
        let dayForm = ["дней", "день", "дня"]
        let remainder10 = count % 10
        let remainder100 = count % 100
        let indexForm: Int
        
        if remainder100 >= 11 && remainder100 <= 14 {
            indexForm = 0
        } else {
            switch remainder10 {
            case 1:
                indexForm = 1
            case 2...4:
                indexForm = 2
            default:
                indexForm = 0
            }
        }
        return ("\(count) \(dayForm[indexForm])")
    }
    private func dayForCompleted (with tracker: Tracker) {
        switch completionButton.currentImage {
        case UIImage(systemName: "plus"):
            colorOfCellView.backgroundColor = tracker.color
        case UIImage(systemName: "checkmark"):
            completionButton.backgroundColor = tracker.color.withAlphaComponent(0.3)
        default:
            break
        }
    }
    //MARK: - Constraint
    private func constraint()  {
        contentView.backgroundColor = .clear
        colorOfCellView.layer.cornerRadius = 16
        
        [colorOfCellView, labelEmoji, nameLabel, completionButton, counterDaysLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            colorOfCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorOfCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorOfCellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorOfCellView.heightAnchor.constraint(equalToConstant: 90),
            
            labelEmoji.topAnchor.constraint(equalTo: colorOfCellView.topAnchor, constant: 12),
            labelEmoji.leadingAnchor.constraint(equalTo: colorOfCellView.leadingAnchor, constant: 12),
            labelEmoji.heightAnchor.constraint(equalToConstant: 24),
            labelEmoji.widthAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorOfCellView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: colorOfCellView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: colorOfCellView.bottomAnchor, constant: -12),
            
            completionButton.trailingAnchor.constraint(equalTo: colorOfCellView.trailingAnchor, constant: -12),
            completionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            completionButton.heightAnchor.constraint(equalToConstant: 34),
            completionButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterDaysLabel.trailingAnchor.constraint(equalTo: completionButton.leadingAnchor, constant: -8),
            counterDaysLabel.centerYAnchor.constraint(equalTo: completionButton.centerYAnchor),
        ])
    }
    
    //MARK: -Target
    
    @objc private func completionButtonTapped() {
        guard let trackerId = trackerId, let indexPath = indexPath else {
            assertionFailure("no tracker and no index")
            return
        }
        if trackersIsCompleted {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}

