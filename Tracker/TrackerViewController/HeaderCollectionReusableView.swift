//
//  HeaderCollectionReusableView.swift
//  Tracker
//
//  Created by Илья on 01.11.2024.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "Header"
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        constraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraint()  {
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            headerLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    func setupTitle(_ title: String) {
        headerLabel.text = title
    }
}
