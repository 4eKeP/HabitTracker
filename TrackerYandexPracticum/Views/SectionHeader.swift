//
//  SectionHeader.swift
//  TrackerYandexPracticum
//
//  Created by admin on 04.12.2023.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
    
    let sectionTitle: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textColor = .ypBlack
        lable.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(sectionTitle)
        
        NSLayoutConstraint.activate([
            sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            sectionTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
