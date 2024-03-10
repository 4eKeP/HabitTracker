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
        datePicker.layer.cornerRadius = 8
        datePicker.layer.masksToBounds = true
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
    
    private lazy var filtersButton: TypeButton = {
        let filtersButton = TypeButton()
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.setTitle(Resources.TrackerControllerConstants.Labels.filtersTitel, for: .normal)
        filtersButton.setTitleColor(.white, for: .normal)
        filtersButton.backgroundColor = .ypBlue
        filtersButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        filtersButton.addTarget(self, action: #selector(filtersButtonClicked), for: .touchUpInside)
        return filtersButton
    }()
    
    private var weekday = 0
    
    private var searchBarUserInput = ""
    
    private var currentDate: Date {
        factory.selectedDate
    }
    
    private var selectedFilterIndex = 0 {
        didSet {
            factory.selectedFilterIndex = selectedFilterIndex
        }
    }
    
    private let trackersPerLine: CGFloat = Resources.TrackerControllerConstants.trackersPerLine
    
    private let smallSpacing: CGFloat = Resources.TrackerControllerConstants.smallSpacing
    
    private let spacing: CGFloat = Resources.TrackerControllerConstants.spacing
    
    private let collectionHeight:CGFloat = Resources.TrackerControllerConstants.collectionHeight
    
    private let sectionHeight: CGFloat = Resources.TrackerControllerConstants.sectionHeight
    
    private let factory = TrackersFactoryCD.shared
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private let analyticService = AnalyticService()
    
    private var visibleCategories: [TrackerCategory] = []
    
    private var isVisibleCategoriesEmpty: Bool {
        return visibleCategories.filter { !$0.trackers.isEmpty }.isEmpty
    }
    
    // MARK: - viewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        searchBar.searchBar.delegate = self
        factory.selectedDate = Date()
        setupUI()
        fetchVisibleCategoriesFromFactory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCollectionView()
        analyticService.report(name: "open", parameters: ["screen": "Main"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        analyticService.report(name: "close", parameters: ["screen": "Main"])
    }
}
// MARK: - private func
private extension TrackerController {
    
    @objc func addButtonClicked() {
        analyticService.report(name: "click", parameters: ["screen": "Main", "item": "add_track"])
        let nextController = TrackerTypeController()
        nextController.modalPresentationStyle = .popover
        nextController.delegate = self
        navigationController?.present(nextController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        analyticService.report(name: "click", parameters: ["screen": "Main", "item": "date"])
        factory.selectedDate = sender.date
        fetchVisibleCategoriesFromFactory()
        dismiss(animated: true)
    }
    
    @objc func filtersButtonClicked() {
        analyticService.report(name: "click", parameters: ["screen": "Main", "item": "filter"])
        let nextController = FilterController(selectedFilterIndex: selectedFilterIndex)
        nextController.modalPresentationStyle = .popover
        nextController.delegate = self
        navigationController?.present(nextController, animated: true)
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
        filtersButton.isHidden = factory.NoTrackersInCD()
        emptyView.isHidden = !collectionView.isHidden
    }
    
    func fetchTracker(from tracker: Tracker, forIndex index: UUID) {
        factory.saveNewOrUpdate(tracker: tracker, toCategory: index)
        fetchVisibleCategoriesFromFactory()
    }
    
    func setDayForTracker() {
        datePicker.setDate(currentDate, animated: true)
    }
    func clearVisibleCategories() {
        visibleCategories = []
    }
    
    func searchInTrackers() {
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
    
    func useSelectedFilter(for index: Int) {
        selectedFilterIndex = index
        if selectedFilterIndex == 1 {
            factory.selectedDate = Date()
            datePicker.setDate(currentDate, animated: true)
            selectedFilterIndex = 0
        }
        fetchVisibleCategoriesFromFactory()
        filtersButton.setTitleColor(selectedFilterIndex == 0 ? .ypWhite : .ypRed, for: .normal)
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

extension TrackerController: EditTrackerControllerDelegate {
    func editTrackerControllerController(_ viewController: EditTrackerController, didChangedTracker tracker: Tracker, for categoryIndex: UUID) {
        dismiss(animated: true) {
            [weak self] in
            guard let self else { return }
            fetchTracker(from: tracker, forIndex: categoryIndex)
        }
    }
}

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
        fetchVisibleCategoriesFromFactory()
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

extension TrackerController: FilterControllerDelegate {
    func filterViewController(_ viewController: FilterController, didSelect index: Int) {
        dismiss(animated: true) {
            [weak self] in
            guard let self else { return }
            self.useSelectedFilter(for: index)
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
        cell.setTrackerCell = currentTracker
        cell.counter = factory.getRecordsCounter(with: currentTracker.id)
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

//MARK: - UICollectionViewDelegate

extension TrackerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard !indexPaths.isEmpty else { return nil }
        
        let indexPath = indexPaths[0]
        
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isPinned = currentTracker.isPinned
        
        return UIContextMenuConfiguration(actionProvider:  { _ in
            let pinAction = UIAction(title: isPinned ? Resources.ContextMenuList.unpin : Resources.ContextMenuList.pin,
                                     image: isPinned ? Resources.ContextMenuList.unpinImage : Resources.ContextMenuList.pinImage
            ) { [weak self] _ in
                self?.pinCell(indexPath: indexPath)
            }
            
            let editAction = UIAction(title: Resources.ContextMenuList.edit,
                                      image: Resources.ContextMenuList.editImage
            ) { [weak self] _ in
                self?.editCell(indexPath: indexPath)
            }
            let deleteAction = UIAction(title: Resources.ContextMenuList.delete,
                                        image: Resources.ContextMenuList.deleteImage
            ) { [weak self] _ in
                self?.deleteCell(indexPath: indexPath)
            }
            return UIMenu(children: [pinAction, editAction, deleteAction])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return nil }
        return UITargetedPreview(view: cell.contextView)
    }
}

// MARK: - TrackerCellDelegate

extension TrackerController: TrackerCellDelegate {
    func counterButtonTapped(for cell: TrackerCell) {
        guard currentDate.sameDay(Date()) || currentDate.beforeDay(Date()) else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        // guard tracker.schedule[weekday] else { return }
        cell.isDone(factory.setTrackerDone(with: tracker.id, on: currentDate))
        cell.updateCounter(factory.getRecordsCounter(with: tracker.id))
    }
}

// MARK: - UIConstruction

private extension TrackerController {
    func setupUI() {
        view.backgroundColor = .ypWhite
        makeNavBar()
        makeEmptyView()
        addCollectionView()
        setupFiltersButton()
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
    
    //MARK: - ContextMenuCells
    
    func pinCell(indexPath: IndexPath) {
        analyticService.report(name: "click", parameters: ["screen": "Main", "item": "pin"])
        factory.setPinFor(tracker: visibleCategories[indexPath.section].trackers[indexPath.row])
        fetchVisibleCategoriesFromFactory()
    }
    
    func editCell(indexPath: IndexPath) {
        analyticService.report(name: "click", parameters: ["screen": "Main", "item": "edit"])
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let counter = factory.getRecordsCounter(with: tracker.id)
        if let category = factory.fetchCategoryByTracker(id: tracker.id) {
            let trackerToEdit = TrackerForEdit(tracker: tracker,
                                               counter: counter,
                                               category: category)
            let nextController = EditTrackerController(trackerForEdit: trackerToEdit)
            nextController.delegate = self
            present(nextController, animated: true)
        }
    }
    
    func deleteCell(indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil,
                                            message: Resources.ContextMenuList.confirmTrackerDelete,
                                            preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: Resources.ContextMenuList.delete, style: .destructive) { _ in
            self.analyticService.report(name: "click", parameters: ["screen": "Main", "item": "delete"])
            self.factory.delete(tracker: self.visibleCategories[indexPath.section].trackers[indexPath.row])
            self.fetchVisibleCategoriesFromFactory()
        }
        let cancelAction = UIAlertAction(title: Resources.ContextMenuList.cancel, style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
    
    //MARK: - FilterButtonConfig
    
    func setupFiltersButton() {
        view.addSubview(filtersButton)
        
        NSLayoutConstraint.activate([
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.widthAnchor.constraint(equalToConstant: Resources.TrackerControllerConstants.filterWidth),
            filtersButton.heightAnchor.constraint(equalToConstant: Resources.TrackerControllerConstants.filterHeight),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacing)
        ])
    }
}
