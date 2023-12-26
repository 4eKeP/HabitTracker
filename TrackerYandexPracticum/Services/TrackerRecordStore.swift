//
//  TrackerRecordStore.swift
//  TrackerYandexPracticum
//
//  Created by admin on 23.12.2023.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    
    private let context: NSManagedObjectContext
    
    convenience init() {
        guard let application = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("не удалось получить application в TrackerRecord")
        }
        let context = application.persistentContainer.viewContext
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNew(recordDate date: Date, toTracker tracker: TrackerCD) {
        let TrackerRecordInCD = TrackerRecordCD(context: context)
        TrackerRecordInCD.date = date
        TrackerRecordInCD.tracker = tracker
        saveContext()
    }
    
    func removeRecord(on date: Date, toTracker tracker: TrackerCD) {
        let request = TrackerRecordCD.fetchRequest()
        guard let records = try? context.fetch(request) else {
            return assertionFailure("не получилось получить контекст TrackerRecodrCD")}
        records.filter { $0.tracker == tracker }.forEach { if let day = $0.date, day.sameDay(date) { context.delete($0) }
        }
        saveContext()
    }
    
    func countRecords(for tracker: TrackerCD) -> Int {
        fetchRecords(for: tracker).count
    }
    
    func fetchRecords(for tracker: TrackerCD) -> [Date] {
        let request = TrackerRecordCD.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard let records = try? context.fetch(request) else { return [] }
        return records.filter { $0.tracker == tracker }.compactMap { $0.date }
    }
    
    func deleteTrackerRecordFromCD() {
        let request = TrackerRecordCD.fetchRequest()
        let records = try? context.fetch(request)
        records?.forEach { context.delete($0) }
        saveContext()
    }
}

//MARK: - Save Context
private extension TrackerRecordStore {
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("не удалось сохранить context в TrackerRecordStore с ошибкой \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
