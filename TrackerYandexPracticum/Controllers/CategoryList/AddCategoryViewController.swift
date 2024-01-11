//
//  AddCategoryViewController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 11.01.2024.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func AddCategoryViewController(_ viewController: CategoryViewController, didAddCategory category: TrackerCategory)
}

final class AddCategoryViewController: UIViewController {
    
    weak var delegate: AddCategoryViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
