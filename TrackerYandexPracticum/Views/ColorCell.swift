//
//  ColorCell.swift
//  TrackerYandexPracticum
//
//  Created by admin on 17.12.2023.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    static let Identifer = "ColorCollectionCellIdentifer"
    
    private lazy var colorView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.ypWhite.cgColor
        view.layer.borderWidth = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let colorCellHeight: CGFloat = 52
    
    private let colorCellBoarderHeight: CGFloat = 3
    
    private lazy var colorCellSize = {
        colorCellHeight - colorCellBoarderHeight * 2
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: config Emoji cell func
    
    func configColorCell(color: UIColor) {
        colorView.backgroundColor = color
    }
}

private extension ColorCell {
    //MARK: setup emoji cell UI
    private func setupColorView() {
        contentView.addSubview(colorView)
        configureColorCellConstraints()
    }
    
    func configureColorCellConstraints() {
      NSLayoutConstraint.activate([
        colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
        colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        colorView.widthAnchor.constraint(equalToConstant: colorCellSize),
        colorView.heightAnchor.constraint(equalToConstant: colorCellSize)
      ])
    }
}
