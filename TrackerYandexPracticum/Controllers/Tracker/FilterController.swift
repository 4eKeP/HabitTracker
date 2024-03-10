//
//  FilterController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 10.03.2024.
//

import UIKit

protocol FilterControllerDelegate: AnyObject {
    func filterViewController(_ viewController: FilterController, didSelect index: Int)
}

final class FilterController: UIViewController {
    
    private let filtersLabel = Resources.FilterControllerConstants.filtersTitleLabel
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = filtersLabel
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.allowsSelection = true
        tableView.separatorColor = .ypGray
        return tableView
    }()
    
    private var selectedFilterIndex: Int?
    private let spacing = Resources.FilterControllerConstants.spacing
    private let height = Resources.FilterControllerConstants.settingHeight * CGFloat(Resources.FilterControllerConstants.filterMenuLabels.count)
    private let titleSpacing = Resources.FilterControllerConstants.titleSpacing
    private let titleHeight = Resources.FilterControllerConstants.titleHeight
    
    weak var delegate: FilterControllerDelegate?
    
    //MARK: - init
    init(selectedFilterIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.selectedFilterIndex = selectedFilterIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}
//MARK: - UITableViewDelegate
extension FilterController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedFilterIndex = indexPath.row
        delegate?.filterViewController(self, didSelect: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Resources.FilterControllerConstants.settingHeight
    }
}
//MARK: - UITableViewDataSource
extension FilterController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Resources.FilterControllerConstants.filterMenuLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.Identifer, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        cell.configureCell(for: CategoryCellViewModel(categoryName: Resources.FilterControllerConstants.filterMenuLabels[indexPath.row],
                                                      isFirst: indexPath.row == 0,
                                                      isLast: indexPath.row == Resources.FilterControllerConstants.filterMenuLabels.count - 1,
                                                      isSelected: indexPath.row == selectedFilterIndex))
        return cell
    }
}

//MARK: - UI config

private extension FilterController {
    func setupUI() {
        configUI()
        configTableView()
    }
    
    func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.Identifer)
        tableView.reloadData()
    }
    
    func configUI() {
        view.backgroundColor = .ypWhite
        view.addSubview(titleLabel)
        view .addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: titleSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: titleHeight),
            
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: spacing),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -spacing),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            tableView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
