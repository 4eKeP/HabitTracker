//
//  AddCategoryViewController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 11.01.2024.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func addCategoryViewController(_ viewController: AddCategoryViewController, categoryName: String, id: UUID?)
}

final class AddCategoryViewController: UIViewController {
    
    private let titleLabelText = Resources.AddCategoryViewControllerConstants.Labels.titleLabelText
    
    private let textFieldPlaceHolderText = Resources.AddCategoryViewControllerConstants.Labels.textFieldPlaceHolderText
    
    private let addButtonText = Resources.AddCategoryViewControllerConstants.Labels.addButtonText
    
    private let analyticService = AnalyticService.shared
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.text = titleLabelText
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField = {
        let textField = UITextField()
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        textField.leftViewMode = .always
        textField.leftView = spacer
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = textFieldPlaceHolderText
        textField.clearButtonMode = .whileEditing
        textField.textColor = .ypBlack
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var addButton = {
        let button = TypeButton()
        button.setTitle(addButtonText, for: .normal)
        button.setTitleColor(.ypLightGray, for: .disabled)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //private var category: TrackerCategory?
    
    private var categoryNameIsFullfilled: Bool {
        !userInput.isEmpty
    }
    
    private var userInput: String {
        didSet {
            updateAddButtonState()
        }
    }
    
    private let viewModel: AddCategoryViewModelProtocol
    
    private var isEdit = false
    
    
    init(viewModel: AddCategoryViewModelProtocol) {
        self.viewModel = viewModel
        self.userInput = viewModel.category?.categoryName ?? ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .ypWhite
        
        setupUI()
        
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        updateAddButtonState()
        
        textField.delegate = self
        textField.becomeFirstResponder()
    }
    
}

//MARK: - func

private extension AddCategoryViewController {
    
    @objc func addButtonPressed() {
        analyticService.report(name: "click", parameters: ["screen": "category", "item": "create"])
        if let category = viewModel.category {
            viewModel.addNewCategoryButtonPressed(withName: userInput, id: category.id, with: self)
        } else {
            viewModel.addNewCategoryButtonPressed(withName: userInput, id: nil, with: self)
        }
    }
    
    func updateAddButtonState() {
        addButton.backgroundColor = categoryNameIsFullfilled ? .ypBlack : .ypGray
        addButton.isEnabled = categoryNameIsFullfilled
    }
}

//MARK: - UITextFieldDelegate

extension AddCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        userInput = textField.text ?? ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        userInput = textField.text ?? ""
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        true
    }
}

//MARK: - UI configuration

private extension AddCategoryViewController {
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(addButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        let offSet = Resources.AddCategoryViewControllerConstants.addcategoryOffset
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.AddCategoryViewControllerConstants.titleSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Resources.AddCategoryViewControllerConstants.titleHeight),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: offSet),
            textField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: offSet),
            textField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -offSet),
            textField.heightAnchor.constraint(equalToConstant: Resources.AddCategoryViewControllerConstants.addCategoryFieldHeight),
            
            addButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: offSet),
            addButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -offSet),
            addButton.heightAnchor.constraint(equalToConstant: Resources.AddCategoryViewControllerConstants.buttonHeight),
            addButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -offSet)
            
        ])
    }
}
