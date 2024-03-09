//
//  ContextTrackerCell.swift
//  TrackerYandexPracticum
//
//  Created by admin on 09.03.2024.
//

import UIKit

final class ContextTrackerCell: UIView {
    
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
    
    private let pinImageView: UIImageView = {
      let imageView = UIImageView()
        imageView.image = Resources.ContextMenuList.pinFillImage
      imageView.tintColor = .ypWhite
      imageView.contentMode = .scaleAspectFill
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
    }()
    
    var isPinned = false {
        didSet {
            pinImageView.isHidden = !isPinned
        }
    }
    
    var setContextView: Tracker? {
        didSet {
            guard let setContextView else { return }
            cardView.backgroundColor = Resources.colors[setContextView.color]
            cardLabel.text = setContextView.name
            emojiLabel.text = Resources.emojis[setContextView.emoji]
            isPinned = setContextView.isPinned
        }
    }
    
    //MARK: - init
    
    required init(frame: CGRect, tracker: Tracker?) {
        self.setContextView = tracker
        super.init(frame: frame)
        configUI()
        pinImageView.isHidden = !isPinned
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ContextTrackerCell {
    func configUI() {
        self.addSubview(cardView)
        cardView.addSubview(emojiLabel)
        cardView.addSubview(cardLabel)
        cardView.addSubview(pinImageView)
        
        let height = Resources.TrackerCellConstants.height
        let spacing = Resources.TrackerCellConstants.spacing
        let smallSpacing = Resources.TrackerCellConstants.smallSpacing
        let emojiHeight = Resources.TrackerCellConstants.emojiHeight
        
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
        
        pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -spacing),
        pinImageView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
        pinImageView.widthAnchor.constraint(equalToConstant: spacing),
        pinImageView.heightAnchor.constraint(equalToConstant: spacing)

        ])
    }
}
