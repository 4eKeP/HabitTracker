//
//  CategoryViewModel.swift
//  TrackerYandexPracticum
//
//  Created by admin on 11.01.2024.
//

import UIKit

protocol CategoryViewModelProtocol {
    var onChange: (()->Void)? { get set }
    
    var categories: [TrackerCategory] { get }
    
    var selectedCategoryID: UUID? { get set }
    
    var delegate: CategoryViewControllerDelegate? { get set }
    
    func addCategory(_ category: TrackerCategory)
    
    func categorySelected(at indexPath: IndexPath, with controller: CategoryViewController)
    
    func makeViewModel(ForRowAt indexPath: IndexPath) -> CategoryCellViewModel
}

final class CategoryViewModel: CategoryViewModelProtocol {
    
    var onChange: (()->Void)?
    
    var selectedCategoryID: UUID?
    
    weak var delegate: CategoryViewControllerDelegate?
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onChange?()
        }
    }
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    init(selectedCategoryID: UUID) {
        self.selectedCategoryID = selectedCategoryID
        trackerCategoryStore.delegate = self
        fetchCategoriesFromCD()
    }
    
    func fetchCategoriesFromCD() {
        categories = trackerCategoryStore.allCategories.filter { $0.categoryName != Resources.pinCategoriesName }
    }
    
    func addCategory(_ category: TrackerCategory) {
        try? trackerCategoryStore.addNew(category: category)
    }
    
    func categorySelected(at indexPath: IndexPath, with controller: CategoryViewController) {
        selectedCategoryID = categories[indexPath.row].id
        delegate?.categoryViewController(controller, select: categories[indexPath.row])
    }
    
    func makeViewModel(ForRowAt indexPath: IndexPath) -> CategoryCellViewModel {
        
        let currentCategory = categories[indexPath.row]
        let currentViewModel = CategoryCellViewModel(categoryName: currentCategory.categoryName,
                                                      isFirst: indexPath.row == 0,
                                                      isLast: indexPath.row == categories.count - 1,
                                                      isSelected: currentCategory.id == selectedCategoryID)
        return currentViewModel
    }
}

extension CategoryViewModel: TrackerCategoryStoreDelegate {
    func trackerCategoryStore(didUpdate update: TrackerCategoryStore) {
        fetchCategoriesFromCD()
    }
}

