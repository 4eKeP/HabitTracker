//
//  AddCategoryViewModel.swift
//  TrackerYandexPracticum
//
//  Created by admin on 14.01.2024.
//

import Foundation

protocol AddCategoryViewModelProtocol {
    var delegate: AddCategoryViewControllerDelegate? { get set }
    
    func addNewCategoryButtonPressed(withName name: String, id: UUID?, with controller: AddCategoryViewController)
    
}

final class AddCategoryViewModel: AddCategoryViewModelProtocol {
    weak var delegate: AddCategoryViewControllerDelegate?
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    func addNewCategoryButtonPressed(withName name: String, id: UUID?, with controller: AddCategoryViewController) {
        delegate?.addCategoryViewController(controller, categoryName: name, id: id)
    }
}
