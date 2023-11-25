//
//  TabBarController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 25.11.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    // MARK: - Tab setup
    
    private func setupTabs() {
        let tracker = self.createNavigation(with: "Трекер", and: UIImage(named: "tracker_icon"), vc: TrackerController())

        let stats = self.createNavigation(with: "Статистика", and: UIImage(named: "stats_icon"), vc: StatsController())
        
        self.setViewControllers([tracker, stats], animated: true)
    }
    
    private func createNavigation(with title: String,
                                  and image: UIImage?,
                                  vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        
        return nav
    }
}
