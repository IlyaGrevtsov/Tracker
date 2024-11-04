//
//  Untitled.swift
//  tracker
//
//  Created by Илья on 29.09.2024.
//

import UIKit

final class TrackerViewController: UIViewController, UICollectionViewDelegate {

    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentCategories: [TrackerCategory] = []
    var currentDate: Date = Date()
    private var dataFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let buttonImage = UIImage(systemName: "plus")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let addButton = UIBarButtonItem(
            image: buttonImage,
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        return addButton
    }()
    
    private lazy var searchBar: UISearchController = {
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.automaticallyShowsCancelButton = false
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.placeholder = "Поиск"
        return searchBar
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    }()
    
    private lazy var placeHolderText: UILabel = {
        let placeHolderText = UILabel()
        placeHolderText.text = "Что будем отслеживать?"
        placeHolderText.font = .systemFont(ofSize: 12)
        return placeHolderText
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let placeholderImage = UIImageView()
        placeholderImage.image = UIImage(named: "star")
        placeholderImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        placeholderImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return placeholderImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupPlaceholder()
        setupCollectionView()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        addButton.tintColor = .black
        addButton.target = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Трекер"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.searchController = searchBar
        navigationItem.leftBarButtonItem = addButton
    }
    //MARK: -Placeholder
    private func setupPlaceholder() {
        view.addSubview(placeholderImage)
        view.addSubview(placeHolderText)
        
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeHolderText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeHolderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }
    //MARK: -CollectionView
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
   }()
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
    
        
    //MARK: -Target
   
    @objc private func addButtonTapped () {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.navigationItem.title = "Создание трекера"
        
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationController, animated: true, completion: nil)
    }
}
//-MARK: -Extension
extension TrackerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategories.count
    }
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.id == id && isSameDay
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains {TrackerRecord in
            isSameTrackerRecord(trackerRecord: TrackerRecord, id: id)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.cellIdentifier, for: indexPath) as? TrackerCollectionViewCell else {
            assertionFailure("Не удалось создать ячейку")
            return UICollectionViewCell() }
        guard indexPath.section < currentCategories.count else {
            assertionFailure("Индекс секции вне диапозона")
            return UICollectionViewCell()
        }
        let trakers = currentCategories[indexPath.section].trackers
        guard indexPath.row < trakers.count else {
            assertionFailure("Индекс строки вне диапозона")
            return UICollectionViewCell()
        }
        let tracker = currentCategories[indexPath.section].trackers[indexPath.row]
        //        cell.delegate = self
        let isCompletedToDay = isTrackerCompletedToday(id: tracker.id)
        let completedDay = completedTrackers.filter {
            $0.id == tracker.id
        }.count
        
        cell.configure(
            with: tracker,
            trackersIsCompleted: isCompletedToDay,
            completedDays: completedDay,
            indexPath: indexPath)
        return cell
    }
}
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let elementPerRows: CGFloat = 2
        let paddingSpace: CGFloat = 9
        let avalibleWidth: CGFloat = collectionView.bounds.width - paddingSpace
        let widthPerItem: CGFloat = avalibleWidth / elementPerRows
        return CGSize(width: widthPerItem, height: 148)
    }
}
    extension TrackerViewController: TrackerViewCellDelegate {
        func completeTracker(id: UUID, at indexPath: IndexPath) {
            if currentDate <= Date() {
                let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
                completedTrackers.insert(trackerRecord)
                collectionView.reloadItems(at: [indexPath])
            }
        }
        func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
            completedTrackers = completedTrackers.filter { trackerRecord in
                !isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
            }
            collectionView.reloadItems(at: [indexPath])
        }
        
        func record(_ sender: Bool, _ cell: TrackerCollectionViewCell) {
            guard let indexPath = collectionView.indexPath(for: cell) else { return }
            let id = currentCategories[indexPath.section].trackers[indexPath.row].id
            let newRecord = TrackerRecord(id: id, date: currentDate)
            
            switch sender {
            case true:
                completedTrackers.insert(newRecord)
            case false:
                completedTrackers.remove(newRecord)
            }
            
            collectionView.reloadItems(at: [indexPath])
        }
    }
