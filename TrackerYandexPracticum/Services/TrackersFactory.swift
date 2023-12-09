//
//  TrackersFactory.swift
//  TrackerYandexPracticum
//
//  Created by admin on 04.12.2023.
//

import Foundation


final class TrackersFactory {
    private (set) var trackers: [Tracker] = []
    private (set) var categories: [TrackerCategory] = []
    private (set) var complitedTrackers: [TrackerRecord] = []
    
    static let shared = TrackersFactory()
    
    
    func addTracker(_ tracker: Tracker, toCategory index: Int) {
        addNewTracker(tracker: tracker)
        addNewComplitedTracker(tracker: tracker)
        var currentCtegories = categories
        let currentCategory = currentCtegories[index]
        var categoryTrackers = currentCategory.trackers
        categoryTrackers.append(tracker)
        let updatedCategory = TrackerCategory(id: currentCategory.id,
                                              categoryName: currentCategory.categoryName,
                                              trackers: categoryTrackers)
        currentCtegories.remove(at: index)
        currentCtegories.append(updatedCategory)
        categories = currentCtegories
    }
    
    func addNew(category: TrackerCategory) {
        categories.append(category)
    }
    
    func setTrackerDone(TrackerID id: UUID, date: Date) -> (Int, Bool) {
        var isCompleted = false
        var currentComplitedTrackers = complitedTrackers
        let index = findCompletedTrackerIndex(id: id)
        let currentCompletedTracker = currentComplitedTrackers[index]
        var newDates = currentCompletedTracker.dates
        // проверка наличия переданной даты в массиве newDates. Если дата уже присутствует в массиве, она удаляется. В противном случае, дата добавляется в массив newDates
        if let newDatesIndex = newDates.firstIndex(where:
                                                    { Calendar.current.compare($0,
                                                                               to: date,
                                                                               toGranularity: .day) == .orderedSame})
        {
            newDates.remove(at: newDatesIndex)
        } else {
            newDates.append(date)
            isCompleted = true
        }
        let updateCopletedTracker = TrackerRecord(id: currentCompletedTracker.id,
                                                  tracker: currentCompletedTracker.tracker,
                                                  dates: newDates,
                                                  days: newDates.count)
        currentComplitedTrackers.remove(at: index)
        currentComplitedTrackers.append(updateCopletedTracker)
        complitedTrackers = currentComplitedTrackers
        return (newDates.count, isCompleted)
    }
    
    func getNumberOfDays(TrackerID id: UUID, date: Date) -> (Int, Bool) {
        let tracker = complitedTrackers[findCompletedTrackerIndex(id: id)]
        guard tracker.dates.firstIndex(where: {
            Calendar.current.compare($0,
                                     to: date,
                                     toGranularity: .day) == .orderedSame
        }) != nil else {
            return (tracker.days, false)
        }
        return (tracker.days, true)
    }
    
}

private extension TrackersFactory {
    func addNewTracker(tracker: Tracker) {
        trackers.append(tracker)
    }
    
    func addNewComplitedTracker(tracker: Tracker) {
        complitedTrackers.append(TrackerRecord(id: UUID(), tracker: tracker, dates: [], days: [].count))
    }
    
    func findTrackerIndex(id: UUID) -> Int {
        guard let index = trackers.firstIndex(where: {$0.id == id}) else {
            preconditionFailure("не получилось получить индекс")
        }
        return index
    }
    
    func findCompletedTrackerIndex(id: UUID) -> Int {
        let tracker = trackers[findTrackerIndex(id: id)]
        guard let index = complitedTrackers.firstIndex(where: { $0.tracker == tracker }) else {
            preconditionFailure("не получилось получить индекс")
        }
        return index
    }
}
