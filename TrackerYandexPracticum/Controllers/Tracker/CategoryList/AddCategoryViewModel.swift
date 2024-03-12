//
//  AddCategoryViewModel.swift
//  TrackerYandexPracticum
//
//  Created by admin on 14.01.2024.
//

import Foundation

protocol AddCategoryViewModelProtocol {
    var delegate: AddCategoryViewControllerDelegate? { get set }
   
    var category: TrackerCategory? { get }
    
    func addNewCategoryButtonPressed(withName name: String, id: UUID?, with controller: AddCategoryViewController)
    
}

final class AddCategoryViewModel: AddCategoryViewModelProtocol {
    weak var delegate: AddCategoryViewControllerDelegate?
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    var category: TrackerCategory?
    
    init(category: TrackerCategory?) {
        self.category = category
    }
    
    func addNewCategoryButtonPressed(withName name: String, id: UUID?, with controller: AddCategoryViewController) {
        delegate?.addCategoryViewController(controller, categoryName: name, id: id)
    }
}
