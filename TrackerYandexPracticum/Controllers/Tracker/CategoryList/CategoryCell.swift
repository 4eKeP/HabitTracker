//
//  CategoryCell.swift
//  TrackerYandexPracticum
//
//  Created by admin on 11.01.2024.
//

import UIKit

final class CategoryCell: UITableViewCell{
    
    private let cellView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryLabel = {
        let lable = UILabel()
        lable.numberOfLines = 1
        lable.textAlignment = .natural
        lable.textColor = .ypBlack
        lable.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private let doneMarkImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "checkmark")
        view.tintColor = .ypBlue
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let Identifer = "CategoryCellIdentifer"
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CategoryCell.Identifer)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - functions

extension CategoryCell {
    
    func selectCategory(_ isSelected: Bool) {
        doneMarkImageView.isHidden = !isSelected
    }
    
    func configureCell(for category: CategoryCellViewModel) {
        updateCellAppearance(for: category)
        updateSeparatorInset(for: category)
    }
    
    private func updateCellAppearance(for category: CategoryCellViewModel) {
        categoryLabel.text = category.categoryName
        doneMarkImageView.isHidden = !category.isSelected
        
        let isFirstCell = category.isFirst
        let isLastCell = category.isLast
        
        cellView.layer.maskedCorners = maskedCorners(for: isFirstCell, isLastCell)
    }
    
    private func maskedCorners(for isFirstCell: Bool, _ isLastCell: Bool) -> CACornerMask {
        if isFirstCell && isLastCell {
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if isFirstCell {
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLastCell {
            return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            return []
        }
    }
    
    private func updateSeparatorInset(for category: CategoryCellViewModel) {
        self.separatorInset = category.isLast
        ?
        UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        :
        UIEdgeInsets(
            top: .zero,
            left: Resources.CategoryCellConstants.categoryButtonLeading,
            bottom: .zero,
            right: Resources.CategoryCellConstants.categoryButtonLeading
        )
    }
    
}

//MARK: - setup UI

private extension CategoryCell {
    
    func setupUI() {
        contentView.addSubview(cellView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(doneMarkImageView)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.CategoryCellConstants.leadingOffset),
            categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: doneMarkImageView.leadingAnchor),
            categoryLabel.heightAnchor.constraint(equalToConstant: Resources.CategoryCellConstants.categoryLabelHeight),
            
            doneMarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            doneMarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.CategoryCellConstants.leadingOffset),
            doneMarkImageView.widthAnchor.constraint(equalToConstant: Resources.CategoryCellConstants.doneButtonSize),
            doneMarkImageView.heightAnchor.constraint(equalToConstant: Resources.CategoryCellConstants.doneButtonSize)
        ])
    }
}
