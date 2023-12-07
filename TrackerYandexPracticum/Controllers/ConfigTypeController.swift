//
//  ConfigTypeController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 05.12.2023.
//

import UIKit

final class ConfigTypeController: UIViewController {
    
    var isHabit: Bool
    
    private lazy var settingsViewWidth: CGFloat = {
      view.frame.width - 32
    }()

    private lazy var settingsViewHeight: CGFloat = {
      return isHabit ? 150 : 75
    }()
    
    private lazy var buttonViewWidth: CGFloat = {
      view.frame.width - 40
    }()
    
    private lazy var titleLabel = {
        let titleLable = UILabel()
        titleLable.text = isHabit ? "Новая привычка" : "Новое нерегулярное событие"
        titleLable.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        return titleLable
    }()
    
    private lazy var titleTextField = {
        let textField = UITextField()
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = "Введите название трекера"
        textField.clearButtonMode = .whileEditing
        textField.textColor = .ypBlack
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var warningLabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var textFieldStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var settingsView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(
          x: 0,
          y: 0,
          width: settingsViewWidth,
          height: settingsViewHeight
        )
        return view
    }()
    
    private lazy var categoryButton = {
        let button = SettingsButton()
        button.setPrimaryLable(text: "Категория")
        button.addTarget(self, action: #selector(categoryButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0,
                              y: 0,
                              width: settingsViewWidth,
                              height: 75
        )
        return button
    }()
    
    private lazy var scheduleButton = {
        let button = SettingsButton()
        button.setPrimaryLable(text: "Расписание")
        button.addTarget(self, action: #selector(scheduleButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0,
                              y: 75,
                              width: settingsViewWidth,
                              height: 75
        )
        return button
    }()
    
    private lazy var buttonsStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .ypWhite
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var cancelButton = {
        let button = TypeButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton = {
        let button = TypeButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypLightGray, for: .disabled)
        button.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(isHabit: Bool) {
        self.isHabit = isHabit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func categoryButtonPressed() {
        
    }
    
    @objc private func scheduleButtonPressed() {
        
    }
    
    @objc private func cancelButtonPressed() {
        
    }
    
    @objc private func createButtonPressed() {
        
    }
    
}

// MARK: - UI Configuration

private extension ConfigTypeController {
    
    // MARK: - Title Lable config
    func setTitle() {
        view.addSubview(titleLabel)
       setTitleConstraits()
    }
     func setTitleConstraits() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
          titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
          titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - textField config
    
     func setupTextField() {
        view.addSubview(textFieldStackView)
        textFieldStackView.addArrangedSubview(titleTextField)
        textFieldStackView.addArrangedSubview(warningLabel)
        setTitleTextFieldConstraints()
        setWarningLabelConstraints()
        setTextFieldStackViewConstraints()
    }
    
     func setTitleTextFieldConstraints() {
        NSLayoutConstraint.activate([
          titleTextField.topAnchor.constraint(equalTo: textFieldStackView.topAnchor),
          titleTextField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
          titleTextField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
          titleTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
     func setWarningLabelConstraints() {
        NSLayoutConstraint.activate([
          warningLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
          warningLabel.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
          warningLabel.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
          warningLabel.heightAnchor.constraint(equalToConstant: 37.5)
        ])
    }
    
     func setTextFieldStackViewConstraints() {
        NSLayoutConstraint.activate([
            textFieldStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
          textFieldStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
          textFieldStackView.topAnchor.constraint(
            equalTo: titleLabel.bottomAnchor,
            constant: 24)
        ])
    }
    
   //MARK: - settings fields config
    
     func setupSettings() {
        view.addSubview(settingsView)
        configSettingsConstraints()
        settingsView.addSubview(categoryButton)
        if isHabit {
            let separator = Separators()
            separator.addSeparators(for: settingsView, width: settingsViewWidth - 32, times: 1)
            settingsView.addSubview(scheduleButton)
        }
    }
    
     func configSettingsConstraints() {
        NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            settingsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            settingsView.heightAnchor.constraint(equalToConstant: settingsViewHeight),
            settingsView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 24)
        ])
    }
    
    //MARK: - buttons config
    
     func setupButtons() {
        view.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        configButtonsConstraints()
    }
    
     func configButtonsConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
          buttonsStackView.widthAnchor.constraint(equalToConstant: buttonViewWidth),
          buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
          buttonsStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -16
          )
        ])
    }
}
