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
    
    private let borderHeight = Resources.TabBarConstants.borderHeight
    
    private lazy var borderView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupBorder()
    }
    
    override func viewDidLayoutSubviews() {
        switch view.window?.windowScene?.screen.traitCollection.userInterfaceStyle {
        case .light:
            borderView.backgroundColor = .ypGray
        case .dark:
            borderView.backgroundColor = .black
        case .unspecified:
            borderView.backgroundColor = .black
        case .none:
            borderView.backgroundColor = .black
        @unknown default:
            assertionFailure("Unknown interface style")
        }
    }
    
    // MARK: - Tab setup
    
    private func setupTabs() {
        tabBar.tintColor = .ypBlue
        tabBar.backgroundColor = .ypWhite
        
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
    
    private func setupBorder() {
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        tabBar.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            borderView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            borderView.heightAnchor.constraint(equalToConstant: borderHeight)
        ])
    }
}
