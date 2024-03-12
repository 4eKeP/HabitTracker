//
//  CategoryViewController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 11.01.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func categoryViewController(_ viewController: CategoryViewController, select category: TrackerCategory)
}

final class CategoryViewController: UIViewController {
    
    private let categoryText = Resources.CategoryViewControllerConstants.Labels.categoryText
    
    private let emptyViewText = Resources.CategoryViewControllerConstants.Labels.emptyViewText
    
    private let addButtonText = Resources.CategoryViewControllerConstants.Labels.addButtonText
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.text = categoryText
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyView = {
        let view = EmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setEmptyView(title: emptyViewText,
                          image: UIImage(named: "tracker_placeholder"))
        return view
    }()
    
    private lazy var addButton = {
        let button = TypeButton()
        button.setTitle(addButtonText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = true
        tableView.allowsSelection = true
        tableView.separatorColor = .ypGray
        return tableView
    }()
    
    private var viewModel: CategoryViewModelProtocol
    
    //MARK: - init
    
    init(viewModel: CategoryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .ypWhite
        
        setupUI()
        updateCategoryTableView()
        
        viewModel.onChange = updateCategoryTableView
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.Identifer)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        
    }
}

private extension CategoryViewController {
    func updateCategoryTableView() {
        tableView.reloadData()
        tableView.isHidden = viewModel.categories.isEmpty
        emptyView.isHidden = !tableView.isHidden
    }
    
    @objc func addButtonPressed() {
        let viewModel = AddCategoryViewModel(category: nil)
        let nextController = AddCategoryViewController(viewModel: viewModel)
        viewModel.delegate = self
        present(nextController, animated: true)
    }
    
    func editCategory(indexPath: IndexPath) {
        let viewModel = AddCategoryViewModel(category: self.viewModel.categories[indexPath.row])
        let nextController = AddCategoryViewController(viewModel: viewModel)
        viewModel.delegate = self
        present(nextController, animated: true)
    }
    
    func deleteCategory(indexPath: IndexPath) {
        let category = viewModel.categories[indexPath.row]
        let isEmpty = category.trackers.isEmpty
        let message = isEmpty ? Resources.ContextMenuList.confirmCategoryDelete : Resources.ContextMenuList.cancelCategoryDelete
        let actionSheet = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        if isEmpty {
            let deleteAction = UIAlertAction(title: Resources.ContextMenuList.delete, style: .destructive) { _ in
                self.viewModel.deleteCategoryBy(id: category.id)
            }
            actionSheet.addAction(deleteAction)
        }
        let cancelAction = UIAlertAction(title: Resources.ContextMenuList.cancel, style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
}

//MARK: - AddCategoryViewControllerDelegate

extension CategoryViewController: AddCategoryViewControllerDelegate {
    func addCategoryViewController(_ viewController: AddCategoryViewController, categoryName: String, id: UUID?) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let id {
                self.viewModel.rename(id: id, newName: categoryName)
            } else {
                self.viewModel.addCategory(TrackerCategory(id: UUID(),
                                                           categoryName: categoryName,
                                                           trackers: []))
            }
        }
    }
}

//MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.categorySelected(at: indexPath, with: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.categories.isEmpty ? .zero : Resources.CategoryViewControllerConstants.categoryFieldHeight
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(
                title: Resources.ContextMenuList.edit, image: Resources.ContextMenuList.editImage
            ) { [weak self] _ in
                self?.editCategory(indexPath: indexPath)
            }
            let deleteAction = UIAction(
                title: Resources.ContextMenuList.delete, image: Resources.ContextMenuList.deleteImage, attributes: .destructive
            ) { [weak self] _ in
                self?.deleteCategory(indexPath: indexPath)
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}

//MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.Identifer, for: indexPath) as? CategoryCell else { return UITableViewCell() }
        cell.configureCell(for: viewModel.makeViewModel(ForRowAt: indexPath))
        return cell
    }
}


//MARK: - UI config

private extension CategoryViewController {
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(emptyView)
        view.addSubview(tableView)
        view.addSubview(addButton)
        addConstraints()
    }
    
    func addConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        let categoryOffset = Resources.CategoryViewControllerConstants.categoryOffset
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.CategoryViewControllerConstants.titleSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Resources.CategoryViewControllerConstants.titleHeight),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: categoryOffset),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -categoryOffset),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: categoryOffset),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addButton.topAnchor, constant: -categoryOffset),
            
            emptyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: categoryOffset),
            emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -categoryOffset),
            
            addButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: categoryOffset),
            addButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -categoryOffset),
            addButton.heightAnchor.constraint(equalToConstant: Resources.CategoryViewControllerConstants.buttonHeight),
            addButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -categoryOffset)
            
        ])
        
    }
    
}

