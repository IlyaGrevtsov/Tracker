//
//  Untitled.swift
//  tracker
//
//  Created by Илья on 29.09.2024.
//

import UIKit

final class TrackerViewController: UIViewController {

    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentCategories: [TrackerCategory] = []
    
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
        collectionView.register(.self, forCellWithReuseIdentifier: "cell")
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
