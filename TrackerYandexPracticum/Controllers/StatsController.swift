//
//  StatsController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 25.11.2023.
//

import UIKit

final class StatsController: UIViewController {
    
    private let emptyViewText = Resources.StatsConstants.Labels.emptyViewText

    private var isEmpty = true
    
    private lazy var emptyView = EmptyView()
    
    private let spacingFromTitle: CGFloat = Resources.StatsConstants.spacingFromTitle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypWhite
        
        showPlaceholder()
        addConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyView.isHidden = !isEmpty
    }
    
    private func showPlaceholder() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.setEmptyView(title: emptyViewText,
                               image: UIImage(named: "stats_placeholder"))
        view.addSubview(emptyView)
    }
    
    private func addConstrains() {
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingFromTitle),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
