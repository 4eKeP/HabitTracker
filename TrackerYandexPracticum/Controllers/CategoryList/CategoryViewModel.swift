//
//  CategoryViewModel.swift
//  TrackerYandexPracticum
//
//  Created by admin on 11.01.2024.
//

import Foundation

final class CategoryViewModel {
    
    var onChange: (()->Void)?
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onChange?()
        }
    }
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    init() {
        trackerCategoryStore.delegate = self
    }
    
    func fetchCategoriesFromCD() {
        categories = trackerCategoryStore.allCategories
    }
    
    func addCategory(_ category: TrackerCategory) {
        try? trackerCategoryStore.addNew(category: category)
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func trackerCategoryStore(didUpdate update: TrackerCategoryStoreUpdate) {
        fetchCategoriesFromCD()
    }
}
