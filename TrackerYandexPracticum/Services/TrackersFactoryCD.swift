//
//  TrackersFactory.swift
//  TrackerYandexPracticum
//
//  Created by admin on 04.12.2023.
//

import Foundation


final class TrackersFactoryCD {
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    private var currentWeekDayIndex = 0
    var selectedFilterIndex = 0
    
    static let shared = TrackersFactoryCD()
    
    var visibleCategoriesForWeekDay: [TrackerCategory] {
        var newCategories: [TrackerCategory] = []
        if
            !pinnedTrackers.isEmpty,
            let pinnedCategoryId = trackerCategoryStore.pinnedCategoryId,
            let pinnedCategory = allCategories.first(where: { $0.id == pinnedCategoryId }) {
            newCategories.append(TrackerCategory(id: pinnedCategory.id,
                                                 categoryName: pinnedCategory.categoryName,
                                                 trackers: filteredTrackers(from: pinnedTrackers)))
        }
        
        
        trackerCategoryStore.allCategories.forEach {
            newCategories.append(TrackerCategory(id: $0.id,
                                                 categoryName: $0.categoryName,
                                                 trackers: filteredTrackers(from: $0.trackers.filter { !pinnedTrackers.contains($0) })
                                                ))
        }
        return newCategories.filter { !$0.trackers.isEmpty }
    }
    
    var allCategories: [TrackerCategory] {
        trackerCategoryStore.allCategories
    }
    
    var totalRecords: Int {
        trackerRecordStore.totalRecords
    }
    
    var visibleCategoriesForSearch: [TrackerCategory] {
        trackerCategoryStore.allCategories
    }
    
    var pinnedTrackers: [Tracker] {
        trackerStore.pinnedTrackers
    }
    
    var selectedDate = Date() {
        didSet {
            currentWeekDayIndex = selectedDate.weekdayFromMonday() - 1
        }
    }
    
    private init() {
        // clearDataInCD() //раскомментировать для стирания данных в приложении
    }
}

extension TrackersFactoryCD {
    
    enum FilterType {
        static let complitedTrackers = 2
        static let unComplitedTrackers = 3
    }
    
    func countCategories() -> Int {
        return trackerCategoryStore.countCategories()
    }
    
    func fetchCategoryName(by thisIndex: Int) -> String {
        trackerCategoryStore.fetchCategoryName(by: thisIndex)
    }
    
    func saveNewOrUpdate(tracker: Tracker, toCategory categoryIndex: UUID) {
        if let category = trackerCategoryStore.fetchCategory(by: categoryIndex) {
            try? trackerStore.addNewOrUpdate(tracker: tracker, to: category)
        }
    }
    
    func setTrackerDone(with id: UUID, on date: Date) -> Bool {
        var isCompleted = false
        if isTrackerDone(with: id, on: date) {
            trackerRecordStore.removeRecord(on: date, toTracker: fetchTracker(byID: id))
        } else {
            try? trackerRecordStore.addNew(recordDate: date, toTracker: fetchTracker(byID: id))
            isCompleted.toggle()
        }
        return isCompleted
    }
    
    func isTrackerDone(with id: UUID, on date: Date) -> Bool {
        !trackerRecordStore.fetchRecords(for: fetchTracker(byID: id)).filter { $0.sameDay(date) }.isEmpty
    }
    
    func getRecordsCounter(with id: UUID) -> Int {
        trackerRecordStore.countRecords(for: fetchTracker(byID: id))
    }
    
    
    func filteredTrackers(from trackers: [Tracker]) -> [Tracker] {
        trackers.filter {
            switch selectedFilterIndex {
            case FilterType.complitedTrackers:
                $0.schedule[currentWeekDayIndex] && (isTrackerDone(with: $0.id, on: selectedDate) == true)
            case FilterType.unComplitedTrackers:
                $0.schedule[currentWeekDayIndex] && (isTrackerDone(with: $0.id, on: selectedDate) == false)
            default:
                $0.schedule[currentWeekDayIndex]
            }
        }
    }
    
    func setPinFor(tracker: Tracker) {
        let newPinValue = !tracker.isPinned
        let newTracker = Tracker(id: tracker.id,
                                 name: tracker.name,
                                 color: tracker.color,
                                 emoji: tracker.emoji,
                                 schedule: tracker.schedule,
                                 isPinned: newPinValue)
        try? trackerStore.setPinFor(tracker: newTracker)
    }
    
    func delete(tracker: Tracker) {
        if let trackerInCD = trackerStore.fetchTrackers(byID: tracker.id) {
            trackerRecordStore.deleteRecordFromCD(for: trackerInCD)
            trackerStore.delete(tracker: trackerInCD)
        }
    }
    
    func addNew(category: TrackerCategory) {
        try? trackerCategoryStore.addNew(category: category)
    }
    
    func fetchCategoryByTracker(id: UUID) -> TrackerCategory? {
        guard
            let categoryInCD = trackerStore.fetchCategoryByTracker(id: id),
            let category = try? trackerCategoryStore.trackerCategory(from: categoryInCD) else { return nil }
        return category
    }
    
    func NoTrackersInCD() -> Bool {
        if trackerStore.countTrackers() == 0 {
            return true
        } else {
            return false
        }
    }
}

private extension TrackersFactoryCD {
    
    func fetchTracker(byID id: UUID) -> TrackerCD {
        guard let tracker = trackerStore.fetchTrackers(byID: id) else {
            preconditionFailure("не удалось получить tracker с ID - \(id)")
        }
        return tracker
    }
}
