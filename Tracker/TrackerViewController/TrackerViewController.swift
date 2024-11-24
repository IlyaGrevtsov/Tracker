//
//  Untitled.swift
//  tracker
//
//  Created by Илья on 29.09.2024.
//
import Foundation
import UIKit

final class TrackerViewController: UIViewController {
    //MARK: -Constant
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    var currentDate: Date = Date()
    private var categories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentCategories: [TrackerCategory] = []
    private var isSearching: Bool = false
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
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
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var placeHolderText: UILabel = {
        let placeHolderText = UILabel()
        placeHolderText.text = "Что будем отслеживать?"
        placeHolderText.font = .systemFont(ofSize: 12)
        return placeHolderText
    }()
    
    private let placeholderImage = UIImageView()
    //MARK: -Function
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupPlaceholderImage()
        setupPlaceholder()
        setupCollectionView()
        setupTrackersCollectionView()
        updateUI()
    }
    
    private func setupPlaceholderImage() {
        placeholderImage.image = UIImage(named: "star")!
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderImage)
    }
    
    private func updateUI() {
        if currentCategories.isEmpty {
            showPlaceholder(isSearching: isSearching)
        } else {
            placeHolderText.isHidden = true
            placeholderImage.isHidden = true
            collectionView.isHidden = false
        }
        collectionView.reloadData()
    }
    
    private func showPlaceholder(isSearching: Bool) {
        placeHolderText.text = isSearching ? "Ничего не найдено" : "Что будем отслеживать?"
        placeholderImage.image = UIImage(named: isSearching ? "emoji" : "star")
        placeHolderText.isHidden = false
        placeholderImage.isHidden = false
        collectionView.isHidden = true
        
        NSLayoutConstraint.activate([
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80 ),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ]
        )
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
        
        let currentDate = Date()
        let calendar = Calendar.current
        let minDate = calendar.date(byAdding: .year, value: -10, to: currentDate)
        let maxDate = calendar.date(byAdding: .year, value: 10, to: currentDate)
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    //MARK: -Placeholder
    private func setupPlaceholder() {
        view.addSubview(placeHolderText)
        
        placeHolderText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeHolderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeHolderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }
    //MARK: -CollectionView
    
    
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
    
    private func setupTrackersCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: TrackerCollectionViewCell.cellIdentifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func addTracker(_ tracker: Tracker, to categoryIndex: Int) {
        if categoryIndex < categories.count {
            var updatedTrackers = categories[categoryIndex].trackers
            updatedTrackers.append(tracker)
            let updatedCategory = TrackerCategory(title: categories[categoryIndex].title, trackers: updatedTrackers)
            categories[categoryIndex] = updatedCategory
        } else {
            let newCategory = TrackerCategory(title: "Радостные мелочи", trackers: [tracker])
            categories.append(newCategory)
        }
        currentCategories = categories
        updateUI()
    }
    
    private func filteredTrackers() {
        isSearching = true
        let calendar = Calendar.current
        let selectedWeekDay = calendar.component(.weekday, from: currentDate) - 2
        let selectedDayString = WeekDay(rawValue: selectedWeekDay)?.stringValue ?? ""
        
        currentCategories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return tracker.schedule.contains(selectedDayString)
            }
            return !filteredTrackers.isEmpty ? TrackerCategory(title: category.title, trackers: filteredTrackers) : nil
        }
        updateUI()
    }
    
    
    //MARK: -Target
    
    @objc private func addButtonTapped () {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.navigationItem.title = "Создание трекера"
        createTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationController, animated: true, completion: nil)
    }
    @objc private func datePickerValueChanged (_ sender: UIDatePicker) {
        currentDate = sender.date
        isSearching = false
        filteredTrackers()
        updateUI()
    }
}
//-MARK: -Extension Collection
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        currentCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCategories[section].trackers.count
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
        cell.delegate = self
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
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = HeaderCollectionReusableView.reuseIdentifier
        default:
            return UICollectionReusableView()
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: id,
                                                                   for: indexPath) as! HeaderCollectionReusableView
        let title = currentCategories[indexPath.section].title
        view.setupTitle(title)
        return view
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(
            width: collectionView.frame.width,
            height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
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
extension TrackerViewController: NewTrackerViewControllerDelegate {
    
    func setDateForNewTracker() -> String {
        return dateFormatter.string(from: currentDate)
    }
    
    func didCreateNewTracker(_ tracker: Tracker) {
        addTracker(tracker, to: 0)
    }
}
