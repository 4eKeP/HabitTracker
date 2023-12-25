//
//  TrackerController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 24.11.2023.
//

import UIKit

final class TrackerController: UIViewController {
    
    private lazy var emptyView = {
        var view = EmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCell.self,
                                forCellWithReuseIdentifier: TrackerCell.Identifer)
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeader.Identifer)
        return collectionView
    }()
    
    private lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.backgroundColor = .ypBackground
        datePicker.tintColor = .ypBlue
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.setDate(currentDate, animated: true)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchBar: UISearchController = {
        $0.hidesNavigationBarDuringPresentation = false
        $0.searchBar.placeholder = "Поиск"
        $0.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        $0.searchBar.searchTextField.clearButtonMode = .never
        return $0
    }(UISearchController(searchResultsController: nil))
    
    private var weekday = 0
    
    private var searchBarUserInput = ""
    
    private var currentDate = Date() {
        didSet {
            weekday = currentDate.weekdayFromMonday()
        }
    }
    
    private let trackersPerLine: CGFloat = 2
    
    private let smallSpacing: CGFloat = 9
    
    private let spacing: CGFloat = 16
    
    private let collectionHeight:CGFloat = 148
    
    private let sectionHeight: CGFloat = 46
    
    private let factory = TrackersFactoryCD.shared
    
    private var visibleCategories: [TrackerCategory] = []
    
    private enum Search {
        case text
        case day
    }
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ypWhite
        setupUI()
        searchBar.searchBar.delegate = self
        currentDate = Date()
        setupMockCategories()
        updateCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCollectionView()
    }
    
    @objc func addButtonClicked() {
        let nextController = TrackerTypeController()
        nextController.modalPresentationStyle = .popover
        nextController.delegate = self
        navigationController?.present(nextController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
      currentDate = sender.date
        searchInTrackers(.day)
      dismiss(animated: true)
    }
}
    // MARK: - private func
    private extension TrackerController {
        
        func updateCollectionView() {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutSubviews()
            collectionView.isHidden = visibleCategories.isEmpty
            emptyView.isHidden = !collectionView.isHidden
        }
        
        func fetchTracker(from tracker: Tracker, forIndex Index: Int) {
            factory.addTracker(tracker, toCategory: Index)
            fetchVisibleCategoriesfromFactory()
            searchInTrackers(.day)
        }
        func fetchVisibleCategoriesfromFactory() {
            clearVisibleCategories()
            for factoryCategory in factory.categories where !factoryCategory.trackers.isEmpty {
                visibleCategories.append(factoryCategory)
            }
            updateCollectionView()
        }
        
        func clearVisibleCategories() {
            visibleCategories = []
        }
        
        private func searchInTrackers(_ type: Search) {
            
            let currentCategories = factory.categories
            var newCategories: [TrackerCategory] = []
            clearVisibleCategories()
            for currentCategory in currentCategories {
                var currentTrackers: [Tracker] = []
                let trackers = currentCategory.trackers.count
                for index in 0..<trackers {
                    let tracker = currentCategory.trackers[index]
                    switch type {
                    case .text:
                        let tracker = currentCategory.trackers[index]
                        if tracker.name.lowercased().contains(searchBarUserInput.lowercased()) {
                            currentTrackers.append(tracker)
                        }
                    case .day:
                        let trackerHaveThisDay = tracker.schedule[weekday - 1]
                        if trackerHaveThisDay {
                            currentTrackers.append(tracker)
                        }
                    }
                }
                if !currentTrackers.isEmpty {
                    newCategories.append(TrackerCategory(id: currentCategory.id,
                                                         categoryName: currentCategory.categoryName,
                                                         trackers: currentTrackers))
                }
            }
            visibleCategories = newCategories
            if !visibleCategories.isEmpty {
                makeEmptyViewForSearchBar()
            }
            updateCollectionView()
        }
}


// MARK: - UISearchBarDelegate

extension TrackerController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarUserInput = searchText
        if searchBarUserInput.count > 1 {
            makeEmptyViewForSearchBar()
            searchInTrackers(.text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        makeEmptyViewForTrackers()
        fetchVisibleCategoriesfromFactory()
    }
}

// MARK: - TrackerTypeControllerDelegate

extension TrackerController: TrackerTypeControllerDelegate {
    func trackerTypeController(_ viewController: TrackerTypeController, didFillTracker tracker: Tracker, for categoryIndex: Int) {
        dismiss(animated: true) {
            [weak self] in
            guard let self = self else { return }
            self.fetchTracker(from: tracker, forIndex: categoryIndex)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - smallSpacing - 2 * spacing) / trackersPerLine,
               height: collectionHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: sectionHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: .zero, left: spacing, bottom: .zero, right: spacing)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories.isEmpty ? 0 : visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.Identifer, for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
        
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let daysSettings = factory.getNumberOfDays(TrackerID: currentTracker.id, date: currentDate)
        let totalDays = daysSettings.0
        let isCompleted = daysSettings.1
        cell.delegate = self
        cell.configCell(backgroundColor: Constants.colors[currentTracker.color], emoji: Constants.emojis[currentTracker.emoji], cardText: currentTracker.name, counter: totalDays)
        cell.isDone(isCompleted)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = SectionHeader.Identifer
        default:
            id = ""
        }
        guard
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? SectionHeader else { return SectionHeader() }
        view.sectionTitle.text = visibleCategories.isEmpty ? "" : visibleCategories[indexPath.section].categoryName
        return view
    }
}

// MARK: - TrackerCellDelegate

extension TrackerController: TrackerCellDelegate {
    func counterButtonTapped(for cell: TrackerCell) {
        guard
            Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedAscending
                || Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedSame
        else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        guard tracker.schedule[weekday - 1] else { return }
        let daysSettings = factory.setTrackerDone(TrackerID: tracker.id, date: currentDate)
        cell.updateCounter(daysSettings.0)
        cell.isDone(daysSettings.1)
    }
}

// MARK: - UIConstruction

private extension TrackerController {
     func setupUI() {
        makeNavBar()
        makeEmptyView()
        addCollectionView()
    }
    
    //MARK: - NavBar
      func makeNavBar() {
          let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        plusButton.tintColor = .ypBlack
        
        self.navigationItem.leftBarButtonItem = plusButton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        self.navigationController?.navigationBar.topItem?.searchController = searchBar
    }
    
    //MARK: - EmptyView
     func makeEmptyView() {
         emptyView.setEmptyView(
           title: "Что будем отслеживать?",
           image: UIImage(named: "tracker_placeholder")
         )
         view.addSubview(emptyView)
         addEmptyViewConstrains()
    }
    
    func makeEmptyViewForTrackers() {
      emptyView.setEmptyView(title: "Что будем отслеживать?",
                             image: UIImage(named: "tracker_placeholder"))
    }

    func makeEmptyViewForSearchBar() {
        emptyView.setEmptyView(title: "Ничего не найдено",
                               image: UIImage(named: "search_placeholder"))
    }
    
    func addEmptyViewConstrains() {
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -88),
          emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
          emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
          emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - collectionView

    func addCollectionView() {
        configCollectionView()
        view.addSubview(collectionView)
        configCollectionViewConstraints()
    }
    
    func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func configCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
          collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
          collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}

//MARK: Mock Categories
private extension TrackerController {
  func setupMockCategories() {
      factory.addNew(category: TrackerCategory(id: UUID(), categoryName: "Важное", trackers: []))
      factory.addNew(category: TrackerCategory(id: UUID(), categoryName: "Домашний уют", trackers: []))
  }
}
