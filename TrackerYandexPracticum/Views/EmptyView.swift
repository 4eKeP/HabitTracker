//
//  EmptyView.swift
//  TrackerYandexPracticum
//
//  Created by admin on 07.12.2023.
//

import UIKit

final class EmptyView: UIView {
    
    private lazy var backgroundView = UIView()
    
    private lazy var containerView = UIView()
    
    private lazy var emptyImage = UIImageView()
    
    private lazy var descriptionLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEmptyView(title: String, image: UIImage?) {
        descriptionLabel.text = title
        emptyImage.image = image
    }
    
    // MARK: - setup and constraints
    
    private func setupView() {
        [backgroundView,
         containerView,
         emptyImage,
         descriptionLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(backgroundView)
        backgroundView.addSubview(containerView)
        containerView.addSubview(emptyImage)
        containerView.addSubview(descriptionLabel)
        addConstraintsView()
    }
    
    private func addConstraintsView() {
        let imageSize: CGFloat = 80
        let titleHeight: CGFloat = 18
        let spacing: CGFloat = 9
        let height: CGFloat = imageSize + spacing + titleHeight
        let width: CGFloat = 320 - spacing * 2
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            containerView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: width),
            containerView.heightAnchor.constraint(equalToConstant: height),

            emptyImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emptyImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            emptyImage.widthAnchor.constraint(equalToConstant: imageSize),
            emptyImage.heightAnchor.constraint(equalToConstant: imageSize),

            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -spacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: titleHeight)
        ])
    }
   
}
