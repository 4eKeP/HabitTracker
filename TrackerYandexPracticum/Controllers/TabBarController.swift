//
//  TabBarController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 25.11.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    private let tabBarTrackerText = Resources.TabBarConstants.Labels.tabBarTrackerText
    
    private let tabBarStatsText = Resources.TabBarConstants.Labels.tabBarStatsText
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    // MARK: - Tab setup
    
    private func setupTabs() {
        let tracker = self.createNavigation(with: tabBarTrackerText, and: UIImage(named: "tracker_icon"), vc: TrackerController())

        let stats = self.createNavigation(with: tabBarStatsText, and: UIImage(named: "stats_icon"), vc: StatsController())
        
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
