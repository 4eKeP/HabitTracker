//
//  TrackerCell.swift
//  TrackerYandexPracticum
//
//  Created by admin on 04.12.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
  func counterButtonTapped(for cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {
    
    static let Identifer = "TrackerCollectionCellIdentifer"
    
    // MARK: - properties
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cardLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .ypWhiteAlpha
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var counterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(counterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var counterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus")
        imageView.tintColor = .ypWhite
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
    }
    // MARK: - Private methods
    
     func configCell(backgroundColor: UIColor, emoji: String, cardText: String, counter: Int) {
        cardView.backgroundColor = backgroundColor
        counterButton.backgroundColor = backgroundColor
        cardLabel.text = cardText
        emojiLabel.text = emoji
        updateCounter(counter)
    }
    
     func updateCounter(_ counter: Int){
         counterLabel.text = String.localizedStringWithFormat(
           NSLocalizedString("numberOfDays", comment: "Counter of total tracker's completed days"),
           counter
         )
    }
    
    @objc private func counterButtonTapped() {
        delegate?.counterButtonTapped(for: self)
    }
    
    // MARK: - Public methods
    
    func isDone(_ isDone: Bool) {
        counterImageView.image = isDone ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        counterButton.alpha = isDone ? 0.7 : 1
    }
}
   

// MARK: - UISetup

private extension TrackerCell {
    func setupCell() {
        addCellSubviews()
        addCellConstraints()
    }
    
    func addCellSubviews() {
        [cardView,
         cardLabel,
         emojiLabel,
         counterButton,
         counterLabel,
         counterImageView
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    func addCellConstraints() {
        let height: CGFloat = 90
        let spacing: CGFloat = 12
        let smallSpacing: CGFloat = 8
        let bigSpacing: CGFloat = 16
        let cornerRadius: CGFloat = 32
        let emojiHeight: CGFloat = 24
        
        NSLayoutConstraint.activate([
        
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.heightAnchor.constraint(equalToConstant: height),
            
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: spacing),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: spacing),
            emojiLabel.widthAnchor.constraint(equalToConstant: emojiHeight),
            emojiLabel.heightAnchor.constraint(equalToConstant: emojiHeight),
            
            cardLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: spacing),
            cardLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -spacing),
            cardLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: smallSpacing),
            cardLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -spacing),
            
            counterButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: smallSpacing),
            counterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            counterButton.widthAnchor.constraint(equalToConstant: cornerRadius),
            counterButton.heightAnchor.constraint(equalToConstant: cornerRadius),
            
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            counterLabel.trailingAnchor.constraint(equalTo: counterButton.leadingAnchor, constant: -smallSpacing),
            counterLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: bigSpacing),
            counterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing * 2),
            
            counterImageView.centerXAnchor.constraint(equalTo: counterButton.centerXAnchor),
            counterImageView.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor),
            counterImageView.widthAnchor.constraint(equalToConstant: spacing),
            counterImageView.heightAnchor.constraint(equalToConstant: spacing)
        ])
    }
}
