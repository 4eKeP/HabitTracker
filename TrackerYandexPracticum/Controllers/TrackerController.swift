//
//  TrackerController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 24.11.2023.
//

import UIKit

final class TrackerController: UIViewController {
    
    private let searchBarPlaceHolderText = Resources.TrackerControllerConstants.Labels.searchBarPlaceHolderText
    
    private let cancelButtonText = Resources.TrackerControllerConstants.Labels.cancelButtonText
    
    private let emptyViewText = Resources.TrackerControllerConstants.Labels.emptyViewText
    
    private let emptyViewSearchText = Resources.TrackerControllerConstants.Labels.emptyViewSearchText
    
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
        datePicker.calendar.firstWeekday = 2
        datePicker.setDate(currentDate, animated: true)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var searchBar: UISearchController = {
        $0.hidesNavigationBarDuringPresentation = false
        $0.searchBar.placeholder = searchBarPlaceHolderText
        $0.searchBar.setValue(cancelButtonText, forKey: "cancelButtonText")
        $0.searchBar.searchTextField.clearButtonMode = .never
        return $0
    }(UISearchController(searchResultsController: nil))
    
    private var weekday = 0
    
    private var searchBarUserInput = ""
    
    private var currentDate = Date() {
        didSet {
            weekday = currentDate.weekdayFromMonday() - 1
            factory.setCurrentWeekDay(to: currentDate)
        }
    }
    
    private let trackersPerLine: CGFloat = Resources.TrackerControllerConstants.trackersPerLine
    
    private let smallSpacing: CGFloat = Resources.TrackerControllerConstants.smallSpacing
    
    private let spacing: CGFloat = Resources.TrackerControllerConstants.spacing
    
    private let collectionHeight:CGFloat = Resources.TrackerControllerConstants.collectionHeight
    
    private let sectionHeight: CGFloat = Resources.TrackerControllerConstants.sectionHeight
    
    private let factory = TrackersFactoryCD.shared
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private let trackerStore = TrackerStore()
    
    private var visibleCategories: [TrackerCategory] = []
    
    private var isVisibleCategoriesEmpty: Bool {
        return visibleCategories.filter { !$0.trackers.isEmpty }.isEmpty
    }
    
    // MARK: - viewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .ypWhite
        searchBar.searchBar.delegate = self
        trackerStore.delegate = self
        currentDate = Date()
        setupUI()
        fetchVisibleCategoriesFromFactory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCollectionView()
    }
}
// MARK: - private func
private extension TrackerController {
    
    @objc func addButtonClicked() {
        let nextController = TrackerTypeController()
        nextController.modalPresentationStyle = .popover
        nextController.delegate = self
        navigationController?.present(nextController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        fetchVisibleCategoriesfromFactory()
        dismiss(animated: true)
    }
    
    func fetchVisibleCategoriesFromFactory() {
        clearVisibleCategories()
        visibleCategories = factory.visibleCategoriesForWeekDay
        updateCollectionView()
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutSubviews()
        collectionView.isHidden = visibleCategories.isEmpty
        emptyView.isHidden = !collectionView.isHidden
    }
    
    func fetchTracker(from tracker: Tracker, forIndex Index: UUID) {
        factory.saveNew(tracker: tracker, toCategory: Index)
        setDayForTracker()
        fetchVisibleCategoriesfromFactory()
    }
    
    func setDayForTracker() {
        datePicker.setDate(currentDate, animated: true)
    }
    
    func fetchVisibleCategoriesfromFactory() {
        clearVisibleCategories()
        visibleCategories = factory.visibleCategoriesForWeekDay
        updateCollectionView()
    }
    
    func clearVisibleCategories() {
        visibleCategories = []
    }
    
    private func searchInTrackers() {
        let currentCategory = factory.visibleCategoriesForSearch
        var newCategories: [TrackerCategory] = []
        currentCategory.forEach { category in
            newCategories.append(TrackerCategory(id: category.id,
                                                 categoryName: category.categoryName,
                                                 trackers: category.trackers.filter { $0.name.lowercased().contains(searchBarUserInput.lowercased()) }
                                                )
            )
        }
        visibleCategories = newCategories.filter { !$0.trackers.isEmpty }
        updateCollectionView()
    }
    
}

// MARK: - TrackerStoreDelegate

extension TrackerController: TrackerStoreDelegate {
    func trackerStore(didUpdate update: TrackerStoreUpdate) {
        visibleCategories = factory.visibleCategoriesForWeekDay
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: update.updatedIndexes)
            collectionView.insertItems(at: update.insertedIndexes)
            collectionView.deleteItems(at: update.deletedIndexes)
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate

//extension TrackerController: TrackerCategoryStoreDelegate {
//    func trackerCategoryStore(didUpdate update: TrackerCategoryStoreUpdate) {
//        visibleCategories = factory.visibleCategoriesForWeekDay
//        collectionView.performBatchUpdates {
//            collectionView.reloadSections(update.updatedSectionIndexes)
//            collectionView.insertSections(update.insertedSectionIndexes)
//            collectionView.deleteSections(update.deletedSectionIndexes)
//        }
//    }
//}


// MARK: - UISearchBarDelegate

extension TrackerController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarUserInput = searchText
        if searchBarUserInput.count > 0 {
            makeEmptyViewForSearchBar()
            searchInTrackers()
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
    func trackerTypeController(_ viewController: TrackerTypeController, didFillTracker tracker: Tracker, for categoryIndex: UUID) {
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
        return isVisibleCategoriesEmpty ? 0 : visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.Identifer, for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
        
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        cell.delegate = self
        cell.configCell(backgroundColor: Resources.colors[currentTracker.color],
                        emoji: Resources.emojis[currentTracker.emoji],
                        cardText: currentTracker.name,
                        counter: factory.getRecordsCounter(with: currentTracker.id))
        cell.isDone(factory.isTrackerDone(with: currentTracker.id, on: currentDate))
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
        
        guard currentDate.sameDay(Date()) || currentDate.beforeDay(Date()) else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        guard tracker.schedule[weekday] else { return }
        cell.isDone(factory.setTrackerDone(with: tracker.id, on: currentDate))
        cell.updateCounter(factory.getRecordsCounter(with: tracker.id))
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
            title: emptyViewText,
            image: UIImage(named: "tracker_placeholder")
        )
        view.addSubview(emptyView)
        addEmptyViewConstrains()
    }
    
    func makeEmptyViewForTrackers() {
        emptyView.setEmptyView(title: emptyViewText,
                               image: UIImage(named: "tracker_placeholder"))
    }
    
    func makeEmptyViewForSearchBar() {
        emptyView.setEmptyView(title: emptyViewSearchText,
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
