//
//  TabBarViewController.swift
//  MindCurve
//
//  Created by Ihor Orlenko on 09.08.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }

    func configureTabBar() {
        let memoryListVC = MemoryListTableViewController()
        let memoryCalendarVC = MemoryCalendarViewController()
        let settingsVC = SettingsViewController()
        
        let nav1 = UINavigationController(rootViewController: memoryListVC)
        let nav2 = UINavigationController(rootViewController: memoryCalendarVC)
        let nav3 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Memories", image: .init(systemName: "brain.head.profile"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Calendar", image: .init(systemName: "calendar"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Settings", image: .init(systemName: "gear"), tag: 3)
        
        for nav in [nav1, nav2, nav3] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
    
}
