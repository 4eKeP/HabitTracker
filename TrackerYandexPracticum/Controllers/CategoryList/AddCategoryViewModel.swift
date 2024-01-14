//
//  AddCategoryViewModel.swift
//  TrackerYandexPracticum
//
//  Created by admin on 14.01.2024.
//

import Foundation

protocol AddCategoryViewModelProtocol {
    var delegate: AddCategoryViewControllerDelegate? { get set }
    
    func addNewCategoryButtonPressed(withName name: String, with controller: AddCategoryViewController)
   
}

final class AddCategoryViewModel: AddCategoryViewModelProtocol {
   weak var delegate: AddCategoryViewControllerDelegate?
    
    func addNewCategoryButtonPressed(withName name: String, with controller: AddCategoryViewController) {
        let newCategory = TrackerCategory(id: UUID(), categoryName: name, trackers: [])
        delegate?.addCategoryViewController(controller, didAddCategory: newCategory)
    }
}
