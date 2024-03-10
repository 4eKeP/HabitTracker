//
//  StatsController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 25.11.2023.
//

import UIKit

final class StatsController: UIViewController {
    
    private lazy var statBestPeriod = StatisticsView()
    private lazy var statIdealDays = StatisticsView()
    private lazy var statCompleted = StatisticsView()
    private lazy var statAverage = StatisticsView()
    private lazy var stackView = UIStackView()
    private lazy var emptyView = EmptyView()
    
    private let spacingFromTitle: CGFloat = Resources.StatsConstants.spacingFromTitle
    
    private let emptyViewText = Resources.StatsConstants.Labels.emptyViewText
    
    private let spacing = Resources.StatsConstants.statSectionSpacing
    
    private let statHeight = Resources.StatsConstants.statHeight
    
    private lazy var statWidth: CGFloat = {
        view.frame.width - 2 * spacing
    }()
    
    private let factory = TrackersFactoryCD.shared
    
    private var completedTrackersCounter: Int = 0 {
        didSet {
            statCompleted.counter = completedTrackersCounter
        }
    }
    
    private var isEmpty: Bool {
        completedTrackersCounter == 0
    }
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatView()
    }
}
//MARK: - private func
private extension StatsController {
    
    func updateStatView() {
        completedTrackersCounter = factory.totalRecords
        emptyView.isHidden = !isEmpty
        stackView.isHidden = isEmpty
    }
    
    func addToStat(_ view: StatisticsView, viewModel: StatisticsViewModel) {
        view.frame.size = CGSize(width: statWidth, height: statHeight)
        view.viewModel = viewModel
        view.translatesAutoresizingMaskIntoConstraints = false
        view.gradientBorder(width: 1, colors: [.ypRed, .ypGreen, .ypBlue])
        stackView.addArrangedSubview(view)
    }
    
}
//MARK: - configUI
private extension StatsController {
    
    func configUI() {
        setupStackView()
        setupEmptyView()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        addToStat(statBestPeriod, viewModel: StatisticsViewModel(counter: .zero, title: Resources.StatsConstants.Labels.statisticsList[0]))
        addToStat(statIdealDays, viewModel: StatisticsViewModel(counter: .zero, title: Resources.StatsConstants.Labels.statisticsList[1]))
        addToStat(statCompleted, viewModel: StatisticsViewModel(counter: .zero, title: Resources.StatsConstants.Labels.statisticsList[2]))
        addToStat(statAverage, viewModel: StatisticsViewModel(counter: .zero, title: Resources.StatsConstants.Labels.statisticsList[3]))
        
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 4 * statHeight + 3 * spacing),
            stackView.widthAnchor.constraint(equalToConstant: statWidth)
        ])
    }
    
     func setupEmptyView() {
             emptyView.translatesAutoresizingMaskIntoConstraints = false
             emptyView.setEmptyView(title: emptyViewText,
                                    image: UIImage(named: "stats_placeholder"))
             view.addSubview(emptyView)
         
         
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacingFromTitle),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
