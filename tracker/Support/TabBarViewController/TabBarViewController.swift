//
//  TabBarViewController.swift
//  tracker
//
//  Created by Илья on 08.10.2024.

//import UIKit
//
//final class TabBarViewController: UITabBarController {
//    
//    let trackerViewController = TrackerViewController()
//    let statisticsViewController = StatisticsViewController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTabBar()
//    }
//    
//    private func setupTabBar() {
//                
//        trackerViewController.title = "Трекеры"
//        statisticsViewController.title = "Статистика"
//        
//        trackerViewController.tabBarItem.image = UIImage(systemName: "record.circle")
//        statisticsViewController.tabBarItem.image = UIImage(systemName: "hare.fill")
//        
//        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
//        trackerNavigationController.navigationBar.prefersLargeTitles = true
//        let statisticNavigationController = UINavigationController(rootViewController: statisticsViewController)
//        statisticNavigationController.navigationBar.prefersLargeTitles = true
//        
//        setViewControllers([trackerNavigationController, statisticNavigationController], animated: true)
//
//    }
//    
//}
