//
//  ConfigHeader.swift
//  TrackerYandexPracticum
//
//  Created by admin on 17.12.2023.
//

import UIKit

final class ConfigHeader: UICollectionReusableView {
    
    static let Identifer = "configCollectionHeaderIdentifer"
    
    private let spacing: CGFloat = 16
    private let spacingToTracker: CGFloat = 12
    private let leadingSection: CGFloat = 28
    
    let sectionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(header: String) {
        sectionTitle.text = header
    }
    
    private func setupView() {
        addSubview(sectionTitle)
        
        NSLayoutConstraint.activate([
            sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingSection),
            sectionTitle.topAnchor.constraint(equalTo: topAnchor),
            sectionTitle.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
