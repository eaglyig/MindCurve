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
        let memoryListVC = MemoListTableViewContoller()
        let settingsVC = SettingsViewController()
        
        let nav1 = UINavigationController(rootViewController: memoryListVC)
        let nav2 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Memos", image: .init(systemName: "brain.head.profile"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Settings", image: .init(systemName: "gear"), tag: 2)
        
        for nav in [nav1, nav2] {
            nav.navigationBar.prefersLargeTitles = false
        }
        
        setViewControllers([nav1, nav2], animated: true)
    }
    
}
