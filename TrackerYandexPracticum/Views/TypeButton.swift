//
//  TypeButton.swift
//  TrackerYandexPracticum
//
//  Created by admin on 05.12.2023.
//

import UIKit

final class TypeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.addTarget(self, action: #selector(didTap), for: .touchDown)
        self.addTarget(self, action: #selector(didUntap), for: .touchUpInside)
    }
    
    private func setupButton() {
        setTitleColor(.ypWhite, for: .normal)
        setTitleColor(.ypLightGray, for: .disabled)
        backgroundColor = .ypBlack
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    @objc private func didTap() {
        self.alpha = 0.7
    }
    @objc private func didUntap() {
        self.alpha = 1.0
    }
}
