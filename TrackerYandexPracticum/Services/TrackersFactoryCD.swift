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
    private var currentWeekDay = 0
    
    static let shared = TrackersFactoryCD()
    
    var visibleCategoriesForWeekDay: [TrackerCategory] {
        let currentCategories = trackerCategoryStore.allCategories
        var newCategories: [TrackerCategory] = []
        currentCategories.forEach { category in
            newCategories.append(TrackerCategory(id: category.id,
                                                 categoryName: category.categoryName,
                                                 trackers: category.trackers.filter {$0.schedule[currentWeekDay]}
                                                )
            )
        }
        return newCategories.filter { !$0.trackers.isEmpty }
    }
    
    var visibleCategoriesForSearch: [TrackerCategory] {
        trackerCategoryStore.allCategories
    }
    
    private init() {
        // clearDataInCD() //раскомментировать для стирания данных в приложении
    }
    
    func countCategories() -> Int {
        return trackerCategoryStore.countCategories()
    }
    
    func fetchCategoryName(by thisIndex: Int) -> String {
        trackerCategoryStore.fetchCategoryName(by: thisIndex)
    }
    
    func saveNew(tracker: Tracker, toCategory categoryIndex: Int) {
        if let category = trackerCategoryStore.fetchCategory(by: categoryIndex) {
            try? trackerStore.addNew(tracker: tracker, to: category)
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
    
    func setCurrentWeekDay(to date: Date) {
        currentWeekDay = date.weekdayFromMonday() - 1
    }
    
    
}
private extension TrackersFactoryCD {
    func clearDataInCD() {
        trackerRecordStore.deleteTrackerRecordFromCD()
        trackerStore.deleteTrackersFromCD()
        trackerCategoryStore.deleteCategoriesFromCD()
    }
    
    func fetchTracker(byID id: UUID) -> TrackerCD {
        guard let tracker = trackerStore.fetchTrackers(byID: id) else {
            preconditionFailure("не удалось получить tracker с ID - \(id)")
        }
        return tracker
    }
}
