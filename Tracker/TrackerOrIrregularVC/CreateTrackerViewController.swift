//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Илья on 24.10.2024.
//

import UIKit
import Foundation

protocol NewTrackerViewControllerDelegate: AnyObject {
    func setDateForNewTracker() -> String
    func didCreateNewTracker(_ tracker: Tracker)
}


final class CreateTrackerViewController: UIViewController {
    private let habitButton = UIButton()
    private let IrregularEventButton = UIButton()
    weak var delegate: NewTrackerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constraint()
    }
    //MARK: Constraint
    private func constraint() {
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
        IrregularEventButton.addTarget(self, action: #selector (irregularEventButtonTapped), for: .touchUpInside)
        
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
    //MARK: -Target
    @objc private func habitButtonTapped () {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.delegate = delegate
        newHabitViewController.navigationItem.title = "Новая привычка"
        navigationController?.isNavigationBarHidden = false
        let navigationController = UINavigationController(rootViewController: newHabitViewController)
        present(navigationController, animated: true, completion: nil)
    }
    @objc private func irregularEventButtonTapped () {
        let irregularEventViewController = IrregularEventViewController()
        irregularEventViewController.delegate = delegate
        
        irregularEventViewController.navigationItem.title = "Новое нерегулярное событие"
        navigationController?.isNavigationBarHidden = false
        let navigationController = UINavigationController(rootViewController: irregularEventViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
