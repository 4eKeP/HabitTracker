//
//  SettingsButton.swift
//  TrackerYandexPracticum
//
//  Created by admin on 06.12.2023.
//

import UIKit

final class SettingsButton: UIButton {
    
    private let primaryLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 1
      label.textAlignment = .natural
      label.textColor = .ypBlack
      label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
      return label
    }()

    private let secondaryLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 1
      label.textAlignment = .natural
      label.textColor = .ypGray
      label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
      label.isHidden = true
      return label
    }()

    private let arrowImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(systemName: "chevron.right")
      imageView.tintColor = .ypGray
      imageView.contentMode = .scaleAspectFill
      return imageView
    }()
    
    private lazy var isRTL = UIView.userInterfaceLayoutDirection(for: primaryLabel.semanticContentAttribute) == .rightToLeft
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(primaryLabel)
        addSubview(secondaryLabel)
        addSubview(arrowImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPrimaryLable(text: String) {
        primaryLabel.text = text
    }
    
    func setSecondaryLable(text: String) {
        secondaryLabel.text = text
        secondaryLabel.isHidden = false
        layoutSubviews()
    }
    
    //динамическое изменение позиции в зависимости от дней недели
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hSpacing: CGFloat = 16
        let iconSize: CGFloat = 24
        let labelHeight: CGFloat = 24

        arrowImageView.frame = CGRect(
          x: isRTL ? iconSize : frame.size.width - iconSize - hSpacing,
          y: (frame.size.height - iconSize / 2 ) / 2,
          width: iconSize / 3,
          height: iconSize / 2
        )

        if secondaryLabel.text == nil {
          primaryLabel.frame = CGRect(
            x: isRTL ? -hSpacing : hSpacing,
            y: (frame.size.height - labelHeight ) / 2,
            width: isRTL ? frame.size.width : frame.size.width - iconSize - hSpacing * 2,
            height: labelHeight
          )
        } else {
          primaryLabel.frame = CGRect(
            x: isRTL ? -hSpacing : hSpacing,
            y: labelHeight / 2,
            width: isRTL ? frame.size.width : frame.size.width - iconSize - hSpacing * 2,
            height: labelHeight
          )
          secondaryLabel.frame = CGRect(
            x: isRTL ? -hSpacing : hSpacing,
            y: labelHeight + labelHeight / 2,
            width: isRTL ? frame.size.width : frame.size.width - iconSize - hSpacing * 2,
            height: labelHeight
          )
        }
    }
}

//MARK: button animation

extension SettingsButton {
    
    override func draw(_ rect: CGRect) {
        self.addTarget(self, action: #selector(didTap), for: .touchDown)
        self.addTarget(self, action: #selector(didUntap), for: .touchUpInside)
    }
    
    @objc private func didTap() {
        self.alpha = 0.7
    }
    @objc private func didUntap() {
        self.alpha = 1.0
    }
}
