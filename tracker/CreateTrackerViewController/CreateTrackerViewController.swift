//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Илья on 24.10.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    let habitButton = UIButton()
    let IrregularEventButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup ()
    }
    
    private func setup () {
        habitButton.layer.cornerRadius = 16
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        habitButton.tintColor = .white
        habitButton.backgroundColor = .black
        habitButton.addTarget(self, action: #selector (habitButtonTapped), for: .touchUpInside)
        
        IrregularEventButton.layer.cornerRadius = 16
        IrregularEventButton.setTitle("Нерегулярное Событие", for: .normal)
        IrregularEventButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        IrregularEventButton.tintColor = .white
        IrregularEventButton.backgroundColor = .black
        IrregularEventButton.addTarget(self, action: #selector (IrregularEventButtonTapped), for: .touchUpInside)
        
        view.addSubview(habitButton)
        view.addSubview(IrregularEventButton)
        
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        IrregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            IrregularEventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            IrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            IrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            IrregularEventButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func habitButtonTapped () {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.navigationItem.title = "Новая привычка"
        
        let navigationController = UINavigationController(rootViewController: newHabitViewController)
        present(navigationController, animated: true, completion: nil)
    }
    @objc private func IrregularEventButtonTapped () {
        let irregularEventViewController = IrregularEventViewController()
        irregularEventViewController.navigationItem.title = "Новое нерегулярное событие"
        
        let navigationController = UINavigationController(rootViewController: irregularEventViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
