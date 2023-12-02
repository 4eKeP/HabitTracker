//
//  StatsController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 25.11.2023.
//

import UIKit

final class StatsController: UIViewController {

    private lazy var placeholderImage: UIImageView = {
        var view = UIImageView()
        let image = UIImage(named: "stats_placeholder")
        view = UIImageView(image: image)
        return view
    }()
    
    private lazy var placeholderLable: UILabel = {
        var lable = UILabel()
        lable.text = "Анализировать пока нечего"
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        showPlaceholder()
        addConstrains()
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
