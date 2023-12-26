//
//  TrackerCategoryStore.swift
//  TrackerYandexPracticum
//
//  Created by admin on 23.12.2023.
//

import UIKit
import CoreData
//MARK: - Error handling
enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidName
    case decodingErrorInvalidTrackers
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidColor
    case decodingErrorInvalidSchedule
    case decodingError
}


protocol TrackerCategoryStoreDelegate: AnyObject {
  func trackerCategoryStore(didUpdate update: TrackerCategoryStoreUpdate)
}

final class TrackerCategoryStore: NSObject {
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCD>
    
    private var insertedSectionIndexes: IndexSet?
    private var deletedSectionIndexes: IndexSet?
    private var updatedSectionIndexes: IndexSet?
    
    static let shared = TrackerCategoryStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var allCategories: [TrackerCategory] {
        guard let objects = self.fetchedResultsController.fetchedObjects,
              let categories = try? objects.map({try self.trackerCategory(from: $0)}) else { return [] }
        return categories.filter { !$0.trackers.isEmpty }
        
        //            guard let fetchedObjects = self.fetchedResultsController.fetchedObjects else { return [] }
        //
        //            let categories = fetchedObjects.compactMap { object -> TrackerCategory? in
        //                guard let category = try? self.trackerCategory(from: object), !category.trackers.isEmpty else { return nil }
        //                return category
        //            }
        //            return categories
    }
    
    var numberOfSections: Int {
        allCategories.count
    }
    
    convenience override init() {
        guard let application = UIApplication.shared.delegate as? AppDelegate else { fatalError("не удалось получить application в TrackerCategory") }
        
        let context = application.persistentContainer.viewContext
        self.init(context: context)
    }
    //MARK: - Init
    
    private init(context: NSManagedObjectContext) {
        self.context = context
        
        let fetchRequest = TrackerCategoryCD.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCD.categoryName, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultsController = controller
        super.init()
        controller.delegate = self
        try? controller.performFetch()
        if isCategoryCoreDataEmpty() {
            setupCategoryCDWithMockData()
        }
    }
    
    //MARK: - public method
    func numberOfItemsInSection(_ section: Int) -> Int {
        allCategories[section].trackers.count
    }
    
    func deleteCategoriesFromCD() {
        guard !isCategoryCoreDataEmpty() else { return }
        let request = TrackerCategoryCD.fetchRequest()
        let categories = try? context.fetch(request)
        categories?.forEach { context.delete($0) }
        saveContext()
    }
    
    func countCategories() -> Int {
        let request = TrackerCategoryCD.fetchRequest()
        request.resultType = .countResultType
        guard
            let objects = try? context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
            let counter = objects.finalResult?[0] as? Int32
        else {
            return .zero
        }
        return Int(counter)
    }
    
    func fetchCategoryName(by thisIndex: Int) -> String {
        let request = TrackerCategoryCD.fetchRequest()
        request.returnsObjectsAsFaults = false
        var categoryName: String = ""
        guard let categories = try? context.fetch(request) else { return categoryName }
        for (index, category) in categories.enumerated() where index == thisIndex {
            categoryName = category.categoryName ?? ""
        }
        return categoryName
    }
    
    func fetchCategory(by thisIndex: Int) -> TrackerCategoryCD? {
        let request = TrackerCategoryCD.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard let categories = try? context.fetch(request) else { return nil }
        for (index, category) in categories.enumerated() where index == thisIndex {
            return category
        }
        return nil
    }
}

//MARK: - private methods

private extension TrackerCategoryStore {
    func isCategoryCoreDataEmpty() -> Bool {
        let request = TrackerCategoryCD.fetchRequest()
        guard
            let result = try? context.fetch(request),
            result.isEmpty
        else {
            return false
        }
        return true
    }
    
    func setupCategoryCDWithMockData() {
        Constants.categories.forEach { try? addNew(category: TrackerCategory(id: UUID(),
                                                                             categoryName: $0,
                                                                             trackers: []
                                                                            ))
        }
    }
    
    func addNew(category: TrackerCategory) throws {
        let categoryInCD = TrackerCategoryCD(context: context)
        categoryInCD.categoryName = category.categoryName
        categoryInCD.id = category.id
        saveContext()
    }
    
    func trackerCategory(from trackerCategoryCD: TrackerCategoryCD) throws -> TrackerCategory {
        
        guard let id = trackerCategoryCD.id else {
            throw TrackerCategoryStoreError.decodingErrorInvalidId
        }
        guard let categoryName = trackerCategoryCD.categoryName else {
            throw TrackerCategoryStoreError.decodingErrorInvalidName
        }
        guard let trackersFromCD = trackerCategoryCD.trackers else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        var trackers: [Tracker] = []
        try trackersFromCD.forEach { tracker in
            guard
                let tracker = tracker as? TrackerCD,
                let tracker = try? self.tracker(from: tracker)
            else {
                throw TrackerCategoryStoreError.decodingError
            }
            trackers.append(tracker)
        }
        return TrackerCategory(id: id,
                               categoryName: categoryName,
                               trackers: trackers.sorted { $0.name < $1.name } )
                
        
    }
    
    func tracker(from trackerFromCD: TrackerCD) throws -> Tracker {
        guard let id = trackerFromCD.id else {
            throw TrackerCategoryStoreError.decodingErrorInvalidId
        }
        guard let name = trackerFromCD.name else {
            throw TrackerCategoryStoreError.decodingErrorInvalidName
        }
        return Tracker(id: id,
                       name: name,
                       color: Int(trackerFromCD.color),
                       emoji: Int(trackerFromCD.emoji),
                       schedule: [
                        trackerFromCD.monday,
                        trackerFromCD.tuesday,
                        trackerFromCD.wednesday,
                        trackerFromCD.thursday,
                        trackerFromCD.friday,
                        trackerFromCD.satuday,
                        trackerFromCD.sunday
                                 ]
        )
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            insertedSectionIndexes?.insert(sectionIndex)
        case .delete:
            deletedSectionIndexes?.insert(sectionIndex)
        case .update:
            updatedSectionIndexes?.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedFinalIndexes = insertedSectionIndexes,
            let deletedFinalIndexes = deletedSectionIndexes,
            let updatedFinalIndexes = updatedSectionIndexes
        else { return }
        delegate?.trackerCategoryStore(didUpdate: TrackerCategoryStoreUpdate(
            insertedSectionIndexes: insertedFinalIndexes,
            deletedSectionIndexes: deletedFinalIndexes,
            updatedSectionIndexes: updatedFinalIndexes))
        
        insertedSectionIndexes = nil
        deletedSectionIndexes = nil
        updatedSectionIndexes = nil
    }
}

extension TrackerCategoryStore {
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("не удалось сохранить context в TrackerCategoryStore с ошибкой \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


