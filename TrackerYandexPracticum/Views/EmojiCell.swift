//
//  EmojiCell.swift
//  TrackerYandexPracticum
//
//  Created by admin on 17.12.2023.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    static let Identifer = "EmojiCollectionCellIdentifer"
    
    private lazy var emojiLabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let emojiCellHeight: CGFloat = 52
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmojiLable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: config Emoji cell func
    
    func configEmojiCell(emoji: String) {
        emojiLabel.text = emoji
    }
}

private extension EmojiCell {
    //MARK: setup emoji cell UI
    private func setupEmojiLable() {
        contentView.addSubview(emojiLabel)
        configureEmojiCellConstraints()
    }
    
    func configureEmojiCellConstraints() {
      NSLayoutConstraint.activate([
        emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        emojiLabel.widthAnchor.constraint(equalToConstant: emojiCellHeight),
        emojiLabel.heightAnchor.constraint(equalToConstant: emojiCellHeight)
      ])
    }
}

