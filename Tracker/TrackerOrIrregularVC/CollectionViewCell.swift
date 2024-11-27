//
//  CollectionViewCell.swift
//  Tracker
//
//  Created by Илья on 10.11.2024.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CollectionViewCell"
    
    private let emojiView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let colorLabel: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 3
        view.alpha = 0.3
        return view
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override var isSelected: Bool {
        didSet {
            if !emojiLabel.isHidden {
                self.emojiView.isHidden = isSelected ? false : true
            }
            if !colorView.isHidden {
                self.colorLabel.isHidden = isSelected ? false : true
            }
        }
    }
    
    func setEmoji(_ model: String) {
        emojiLabel.text = model
        emojiLabel.isHidden = false
    }
    
    func setColor(_ model: UIColor) {
        colorView.backgroundColor = model
        colorView.isHidden = false
        colorLabel.layer.borderColor = model.cgColor
    }
    
    private func constraint()  {
        contentView.backgroundColor = .clear
        
        [emojiView, emojiLabel, colorView, colorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isHidden = true
            contentView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            emojiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiView.widthAnchor.constraint(equalToConstant: 52),
            emojiView.heightAnchor.constraint(equalToConstant: 52),
            
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            colorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorLabel.widthAnchor.constraint(equalToConstant: 52),
            colorLabel.heightAnchor.constraint(equalToConstant: 52),
            
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
