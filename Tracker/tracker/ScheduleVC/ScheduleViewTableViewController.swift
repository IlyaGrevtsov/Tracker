//
//  ScheduleViewTableViewController.swift
//  Tracker
//
//  Created by Илья on 03.11.2024.
//

import UIKit
protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(_ day: [weekDay: Bool])
}
final class ScheduleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constraints()
        setupDoneButton()
        
    }
    private let dayName = Constant.dayName
    private let doneButton = UIButton()
    private let scheduleTable = UITableView()
    var selecter: [weekDay: Bool] = [:]
    weak var delegate : ScheduleViewControllerDelegate?
    
    private func setupDoneButton() {
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        doneButton.backgroundColor = Colors.buttonActive
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc func doneButtonTapped() {
        delegate?.didSelectSchedule(selecter)
        dismiss(animated: true, completion: nil)
    }
//    private func setupTable() {
//        scheduleTable.backgroundColor = Colors.textFieldBackground
//        scheduleTable.layer.cornerRadius = 16
//        scheduleTable.dataSource = self
//        scheduleTable.delegate = self
//        scheduleTable.isScrollEnabled = false
//        scheduleTable.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
//    }
    
    private func constraints() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
    
    // MARK: - Table view data source
//extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return selecter.count
//    }
//    
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        
////    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//}
