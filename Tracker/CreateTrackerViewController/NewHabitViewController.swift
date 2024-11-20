//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Илья on 24.10.2024.
//

import UIKit

final class NewHabitViewController: UIViewController, UITextFieldDelegate {
    
    
    weak var delegate: NewTrackerViewControllerDelegate?
    
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
    private let trackerType: TrackerType = .habit
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    private let collectionView = UICollectionView (
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        hideKeyboard()
    }
    
    //MARK: -setupUI
    private func setupUI() {
        setupCollectionView()
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
        
        textFiled.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 5
        let lineSpacing: CGFloat = 0
        
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = lineSpacing
        collectionView.collectionViewLayout = layout
        
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.reuseIdentifier)
    }
     func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    
    //MARK: -Constainer
    private func constraint () {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textFiled)
        [textFiled, tableView, collectionView, createButton, cancelButton].forEach{
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
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 476),
            
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 10),
            
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor,constant: 10)
        ])
        
        containerView.layoutIfNeeded()
    }
    
    //MARK: -target
    
    @objc private func createButtonTapped(){
        guard let newTrackerName = textFiled.text else { return }
        guard let date = delegate?.setDateForNewTracker() else {
            return assertionFailure("Date is nill")
        }
        var newTrackerSchedule: [String] = []
        
        switch trackerType {
        case .habit:
            if selectedDays.values.contains(true) {
                newTrackerSchedule = selectedDays.filter {$0.value }.map { $0.key.stringValue }
            }
        case .event:
            newTrackerSchedule = [date]
        }
        
        let newTracker = Tracker(
            id: UUID(),
            name: newTrackerName,
            color: selectedColor ?? .green,
            emoji: selectedEmoji ?? Constant.randomEmoji(),
            schedule: newTrackerSchedule
        )
        delegate?.didCreateNewTracker(newTracker)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange (_ textField: UITextField) {
        let hasText = !(textField.text?.isEmpty ?? true)
        
        createButton.isEnabled = hasText
        createButton.backgroundColor = hasText ? .black : Colors.buttonInactive
    }

}



//MARK: -EXTENSION

extension NewHabitViewController: UITableViewDataSource, UITableViewDelegate{
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
        if indexPath.row == 1 {
            let scheduleView = ScheduleViewController()
            scheduleView.navigationItem.title = "Расписание"
            
            scheduleView.selecter = selectedDays
            scheduleView.delegate = self
            let navigationController = UINavigationController(rootViewController: scheduleView)
            navigationController.isNavigationBarHidden = false
            self.present(navigationController, animated: true, completion: nil)
        }
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
extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Constant.emoji.count
        case 1:
            return Constant.colorSelection.count
        default:
            return 18
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier,
            for: indexPath
        ) as? CollectionViewCell else {
            assertionFailure("Не удалось получить ячейку NewTrackerCollectionViewCell")
            return UICollectionViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.setEmoji(Constant.emoji[indexPath.row])
        default:
            if let color = Constant.colorSelection[indexPath.row] {
                cell.setColor(color)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = CollectionViewHeader.reuseIdentifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath
        ) as? CollectionViewHeader else {
            assertionFailure("Не удалось получить header NewTrackerSupplementaryView")
            return UICollectionReusableView()
        }
        
        let title = Constant.collectionViewTitles[indexPath.section]
        view.setTitle(title)
        
        return view
    }
}
extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingCompressedSize.height)
        
        return headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 6
        let spacing: CGFloat = 5
        
        let totalSpacing = (itemsPerRow - 1) * spacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        
        let itemSize = max(itemWidth, 0)
        return CGSize(width: itemSize, height: itemSize)
    }
    
}
extension NewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForVisibleItems.filter({
            $0.section == indexPath.section
        }).forEach({
            collectionView.deselectItem(at: $0, animated: true)
        })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedEmoji = Constant.emoji[indexPath.row]
        case 1:
            selectedColor = Constant.colorSelection[indexPath.row]
        default:
            break
        }
    }
}


extension NewHabitViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(_ day: [weekDay: Bool]) {
        selectedDays = day
        tableView.reloadData()
    }
}

