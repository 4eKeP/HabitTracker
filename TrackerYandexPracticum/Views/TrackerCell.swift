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
    
   private let height = Resources.TrackerCellConstants.height
   private let spacing = Resources.TrackerCellConstants.spacing
   private let smallSpacing = Resources.TrackerCellConstants.smallSpacing
   private let bigSpacing = Resources.TrackerCellConstants.bigSpacing
   private let cornerRadius = Resources.TrackerCellConstants.cornerRadius
   private let emojiHeight = Resources.TrackerCellConstants.emojiHeight
    
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
    
    lazy var contextView = ContextTrackerCell(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                                                    size: CGSize(width: contentView.frame.width,
                                                                                height: height)),
                                                      tracker: setTrackerCell)
    
    weak var delegate: TrackerCellDelegate?
    
    var setTrackerCell: Tracker? {
        didSet {
            contextView.setContextView = setTrackerCell
            guard let colorIndex = setTrackerCell?.color else { return }
            counterButton.backgroundColor = Resources.colors[colorIndex]
        }
    }
    
    var isPinned = false {
        didSet {
            contextView.isPinned = isPinned
        }
    }
    
    var counter = 0 {
        didSet {
            counterLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "Counter of total tracker's completed days"), counter)
        }
    }
    
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
    
//     func configCell(backgroundColor: UIColor, emoji: String, cardText: String, counter: Int) {
//        cardView.backgroundColor = backgroundColor
//        counterButton.backgroundColor = backgroundColor
//        cardLabel.text = cardText
//        emojiLabel.text = emoji
//        updateCounter(counter)
//    }
    @objc private func counterButtonTapped() {
        delegate?.counterButtonTapped(for: self)
    }
    
    // MARK: - Public methods
    
    func isDone(_ isDone: Bool) {
        counterImageView.image = isDone ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        counterButton.alpha = isDone ? 0.7 : 1
    }
    
    func updateCounter(_ counter: Int){
        counterLabel.text = String.localizedStringWithFormat(
          NSLocalizedString("numberOfDays", comment: "Counter of total tracker's completed days"),
          counter
        )
   }
}
   

// MARK: - UISetup

private extension TrackerCell {
    func setupCell() {
        addCellSubviews()
        addCellConstraints()
    }
    
    func addCellSubviews() {
        [contextView,
         counterButton,
         counterLabel,
         counterImageView
        ].forEach {
            contentView.addSubview($0)
        }
    }
    
    func addCellConstraints() {
        NSLayoutConstraint.activate([
            
            contextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contextView.topAnchor.constraint(equalTo: topAnchor),
            contextView.heightAnchor.constraint(equalToConstant: height),
            
            counterButton.topAnchor.constraint(equalTo: contextView.bottomAnchor, constant: smallSpacing),
            counterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            counterButton.widthAnchor.constraint(equalToConstant: cornerRadius),
            counterButton.heightAnchor.constraint(equalToConstant: cornerRadius),
            
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            counterLabel.trailingAnchor.constraint(equalTo: counterButton.leadingAnchor, constant: -smallSpacing),
            counterLabel.topAnchor.constraint(equalTo: contextView.bottomAnchor, constant: bigSpacing),
            counterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing * 2),
            
            counterImageView.centerXAnchor.constraint(equalTo: counterButton.centerXAnchor),
            counterImageView.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor),
            counterImageView.widthAnchor.constraint(equalToConstant: spacing),
            counterImageView.heightAnchor.constraint(equalToConstant: spacing)
        ])
    }
}
