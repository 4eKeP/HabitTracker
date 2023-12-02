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
    
    var categories: [TrackerCategory] = []
    var complitedTrackers: [TrackerRecord] = []
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.white
            makeNavBar()
            showPlaceholder()
            addConstrains()
        }

    func makeNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
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

