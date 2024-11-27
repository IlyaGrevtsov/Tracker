//
//  TabBar.swift
//  Tracker
//
//  Created by Илья on 24.10.2024.
//

import UIKit

final class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBar()
        makeTabBarBorder ()
    }
    private func setupBar() {
        let trackerViewController = UINavigationController(rootViewController: TrackerViewController())
        trackerViewController.tabBarItem = UITabBarItem(title: "Трэкеры",
                                                        image: UIImage(systemName: "record.circle"),
                                                        selectedImage: nil)
        let statisticsViewController = UINavigationController(rootViewController: StatisticsViewController())
        statisticsViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                           image: UIImage(systemName: "hare.fill"),
                                                           selectedImage: nil)
        viewControllers = [trackerViewController, statisticsViewController]
    }
    private func makeTabBarBorder () {
        let tabBarBord = UIView()
        tabBarBord.backgroundColor = UIColor(red: 174.0 / 255.0, green: 175.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0)
        tabBarBord.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(tabBarBord)
        
        NSLayoutConstraint.activate([
            tabBarBord.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            tabBarBord.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            tabBarBord.topAnchor.constraint(equalTo: tabBar.topAnchor),
            tabBarBord.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
