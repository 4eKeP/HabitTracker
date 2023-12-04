//
//  TrackerController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 24.11.2023.
//

import UIKit

final class TrackerController: UIViewController {

    private lazy var placeholderImage: UIImageView = {
        var view = UIImageView()
        let image = UIImage(named: "tracker_placeholder")
        view = UIImageView(image: image)
        return view
    }()
    
    private lazy var placeholderLable: UILabel = {
        var lable = UILabel()
        lable.text = "Добавьте первый трекер"
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lable
    }()
    
    private lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    private lazy var searchBar: UISearchController = {
      $0.hidesNavigationBarDuringPresentation = false
      $0.searchBar.placeholder = "Поиск"
      $0.searchBar.setValue("Отменить", forKey: "cancelButtonText")
      $0.searchBar.searchTextField.clearButtonMode = .never
      return $0
    }(UISearchController(searchResultsController: nil))
    
    var categories: [TrackerCategory] = []
    var complitedTrackers: [TrackerRecord] = []
    
    
    // MARK: - viewDidLoad
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.white
            makeNavBar()
            showPlaceholder()
            addConstrains()
            searchBar.searchBar.delegate = self
        }
   
}

// MARK: - UISearchBarDelegate

extension TrackerController: UISearchBarDelegate {
    
}

// MARK: - UIConstruction
extension TrackerController {
    
    private func makeNavBar() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        plusButton.tintColor = .ypBlack
        
        self.navigationItem.leftBarButtonItem = plusButton
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        self.navigationController?.navigationBar.topItem?.searchController = searchBar
    }
    
    private func showPlaceholder() {
        [placeholderImage,
         placeholderLable,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func addConstrains() {
        NSLayoutConstraint.activate([
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderLable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderLable.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }
}

