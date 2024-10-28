//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Илья on 24.10.2024.
//

import UIKit

final class NewHabitViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(.self, forCellWithReuseIdentifier: "cell")
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    private let textFiled = UITextField()
    private let categoryButton = UIButton()
    private let schedule = UIButton()
    
    private let cancelButton = UIButton()
    private let createButton = UIButton()
    
    private let tableView = UITableView()
    private let categories = ["Категория", "Расписание"]
    private let cellIdentifier = "cell"
    var selectedDays: [weekDay: Bool] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    //MARK: -setupUI
    private func setupUI() {
        nameTextField()
        setupCreateButton()
        setupCancelButton()
        setupScrollView()
        setupTableView()
        constraint()
    }
    private func setupScrollView() {
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
    }
    private func nameTextField() {
        textFiled.delegate = self
        textFiled.placeholder = "Введите название трекера"
        textFiled.layer.cornerRadius = 16
        textFiled.backgroundColor = Colors.textFieldBackground
        textFiled.layer.masksToBounds = true
        textFiled.textColor = .black
        textFiled.borderStyle = .none
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textFiled.frame.height))
        textFiled.leftView = paddingView
        textFiled.leftViewMode = .always
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.register(NewHabitTableViewController.self, forCellReuseIdentifier: NewHabitTableViewController.reuseIdentifier)
    }
    private func setupCreateButton() {
        createButton.backgroundColor = Colors.buttonInactive
        createButton.titleLabel?.font = .systemFont(ofSize: 16 , weight: .medium)
        createButton.setTitle("Создать", for: .normal)
        createButton.layer.cornerRadius = 16
        createButton.isEnabled = false
        createButton.addTarget(self,
                               action: #selector (createButtonTapped),
                               for: .touchUpInside)
    }
    
    private func setupCancelButton() {
        cancelButton.setTitleColor(Colors.cancelButtonColor, for: .normal)
        cancelButton.layer.borderColor = Colors.cancelButtonColor.cgColor
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16 , weight: .medium)
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self,
                               action: #selector (cancelButtonTapped),
                               for: .touchUpInside)
    }
    
    //MARK: -Constainer
    private func constraint () {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textFiled)
        [textFiled, tableView, createButton, cancelButton].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor ),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            textFiled.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textFiled.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textFiled.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 27),
            textFiled.widthAnchor.constraint(equalToConstant: 343),
            textFiled.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.heightAnchor.constraint(equalToConstant: 150),
            tableView.topAnchor.constraint(equalTo: textFiled.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
        
        ])
    }
    
    //MARK: -target
    
    @objc private func createButtonTapped() {
        guard textFiled.text != nil else { return }
        dismiss(animated: true)
    }
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: -EXTENSION

extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewHabitTableViewCell", for: indexPath) as? NewHabitTableViewController else {
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        cell.setTitle(categories[indexPath.row])
        
        if indexPath.row == 1 {
            let selectedDaysArray = selectedDays.filter { $0.value }.map { $0.key }
            if selectedDaysArray.isEmpty {
                cell.setSelectedDays("")
            } else if selectedDaysArray.count == weekDay.allCases.count {
                cell.setSelectedDays("Каждый день")
            } else {
                let selectedDaysString = selectedDaysArray.map { $0.stringValue }.joined(separator: ", ")
                cell.setSelectedDays(selectedDaysString)
            }
        } else {
            cell.setSelectedDays("")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
}
extension NewHabitViewController: UICollectionViewDataSource, UICollectionViewFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
