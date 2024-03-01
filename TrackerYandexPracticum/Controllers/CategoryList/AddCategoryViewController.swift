//
//  AddCategoryViewController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 11.01.2024.
//

import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func addCategoryViewController(_ viewController: AddCategoryViewController, didAddCategory category: TrackerCategory)
}

final class AddCategoryViewController: UIViewController {
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.text = "Новая категория"
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
        textField.placeholder = "Введите название категории"
        textField.clearButtonMode = .whileEditing
        textField.textColor = .ypBlack
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var addButton = {
       let button = TypeButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypLightGray, for: .disabled)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var categoryNameIsFullfilled = false {
        didSet {
            if categoryNameIsFullfilled {
                updateAddButtonState()
            }
        }
    }
    
    private var userInput = "" {
        didSet {
            categoryNameIsFullfilled = !userInput.isEmpty
        }
    }
    
    private let viewModel: AddCategoryViewModelProtocol
    
    
    init(viewModel: AddCategoryViewModelProtocol) {
        self.viewModel = viewModel
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
        viewModel.addNewCategoryButtonPressed(withName: userInput, with: self)
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
