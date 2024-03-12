//
//  StatisticsView.swift
//  TrackerYandexPracticum
//
//  Created by admin on 10.03.2024.
//

import UIKit

final class StatisticsView: UIView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var viewModel: StatisticsViewModel? {
        didSet {
            guard let viewModel else { return }
            counterLabel.text = String(viewModel.counter)
            descriptionLabel.text = viewModel.title
        }
    }
    
    var counter: Int? {
        didSet {
            guard let counter else { return }
            counterLabel.text = String(counter)
        }
    }
    
    private let spacing = Resources.StatsConstants.spacing
    
    private let counterHeight = Resources.StatsConstants.counterHeight
    
    private let descriptionHeight = Resources.StatsConstants.descriptionHeight
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - configUI
extension StatisticsView {
    func configUI() {
        addSubview(containerView)
        containerView.addSubview(counterLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            counterLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: spacing),
            counterLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -spacing),
            counterLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: spacing),
            counterLabel.heightAnchor.constraint(equalToConstant: counterHeight),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -spacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -spacing),
            descriptionLabel.heightAnchor.constraint(equalToConstant: descriptionHeight),
        ])
    }
}
