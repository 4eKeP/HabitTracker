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
    func trackerCategoryStore(didUpdate update: TrackerCategoryStore)
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
        return categories
     //   return categories.filter { !$0.trackers.isEmpty }
    }
    
    var pinnedCategoryId: UUID? {
        UUID(uuidString: UserDefaults.standard.pinnedCategoryID)
    }
    
    var numberOfSections: Int {
        allCategories.count
    }
    
    private let pinCategoryName = Resources.pinCategoriesName
    
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
        
        setupPinnedCategory()
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
    
    func fetchCategory(by thisIndex: UUID) -> TrackerCategoryCD? {
        let request = TrackerCategoryCD.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard let categories = try? context.fetch(request) else { return nil }
        for category in categories where category.id == thisIndex {
            return category
        }
        return nil
    }
    
    func addNew(category: TrackerCategory) throws {
        let categoryInCD = TrackerCategoryCD(context: context)
        categoryInCD.categoryName = category.categoryName
        categoryInCD.id = category.id
        saveContext()
    }
    
    func renameCategoryBy(id: UUID, newCategoryName: String) {
        guard let category = fetchCategory(by: id) else { return }
        category.categoryName = newCategoryName
        saveContext()
    }
}

//MARK: - private methods

private extension TrackerCategoryStore {
    func isCategoryCoreDataEmpty() -> Bool {
        guard let categories = self.fetchedResultsController.fetchedObjects else { return true }
        return categories.isEmpty
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
                       ], 
                       isPinned: trackerFromCD.isPinned
        )
    }
    
    func setupPinnedCategory() {
        if isCategoryCoreDataEmpty() {
            let pinnedCategoryID = UUID()
            try? addNew(category: TrackerCategory(id: pinnedCategoryID, categoryName: pinCategoryName, trackers: []))
            UserDefaults.standard.pinnedCategoryID = pinnedCategoryID.uuidString
        }
        if let pinnedCategoryId,
           let pinnedCategory = fetchCategory(by: pinnedCategoryId),
           pinnedCategory.categoryName != pinCategoryName {
            renameCategoryBy(id: pinnedCategoryId, newCategoryName: pinCategoryName)
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            delegate?.trackerCategoryStore(didUpdate: self)
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


