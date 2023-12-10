//
//  ConfigTypeController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 05.12.2023.
//

import UIKit

protocol ConfigTypeControllerDelegate: AnyObject {
    func configTypeControllerController(_ viewController: ConfigTypeController, didFilledTracker tracker: Tracker, for categoryIndex: Int)
}

final class ConfigTypeController: UIViewController {
    
    private lazy var settingsViewWidth: CGFloat = {
        view.frame.width - 2 * leadingSpacing
    }()
    
    private lazy var settingsViewHeight: CGFloat = {
        return isHabit ? settingHeight * 2 : settingHeight
    }()
    
    private lazy var buttonViewWidth: CGFloat = {
        view.frame.width - 2 * leadingButton
    }()
    
    private let leadingButton: CGFloat = 20
    
    private let leadingSpacing: CGFloat = 16
    
    private let settingHeight: CGFloat = 75
    
    private let titleSpacing: CGFloat = 28
    
    private let bottomSpacing: CGFloat = 24
    
    private let buttonHeight: CGFloat = 60
    
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
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        textField.leftViewMode = .always
        textField.leftView = spacer
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.textColor = .ypRed
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
                              height: settingHeight
        )
        return button
    }()
    
    private lazy var scheduleButton = {
        let button = SettingsButton()
        button.setPrimaryLable(text: "Расписание")
        button.addTarget(self, action: #selector(scheduleButtonPressed), for: .touchUpInside)
        button.frame = CGRect(x: 0,
                              y: settingHeight,
                              width: settingsViewWidth,
                              height: settingHeight
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
    
    private var schedule = [Bool](repeating: false, count: 7)
    
    private let textFieldLimit = 38
    
    private var formIsFulfilled = false {
        didSet {
            if formIsFulfilled {
                updateCreateButtonState()
            }
        }
    }
    
    private var trackerNameIsFulfilled = false {
        didSet {
            chekConfigState()
        }
    }
    
    private var categoryIsSelected = false {
        didSet {
            chekConfigState()
        }
    }
    
    private var scheduleIsFulfilled = false {
        didSet {
            chekConfigState()
        }
    }
    // выбераеться рандомно для проверки
    private var emojiIsSelected = true
    private var colorIsSelected = true
    
    //MARK: На будущее сделать из isHabit энум что бы легче добавлять новые типы привычек
    private var isHabit: Bool
    
    private var selectedCategoryIndex = 0
    
    private var userInput = "" {
        didSet {
            trackerNameIsFulfilled = true
        }
    }
    
    private let factory = TrackersFactory.shared
    
    weak var delegate: ConfigTypeControllerDelegate?
    
    init(isHabit: Bool) {
        self.isHabit = isHabit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if !isHabit {
            schedule = schedule.map { $0 || true }
            scheduleIsFulfilled = true
        }
        view.backgroundColor = .ypWhite
        setupUI()
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
    }
    //
    @objc private func categoryButtonPressed() {
        //заглушка для категории
        selectedCategoryIndex = Int.random(in: 0..<factory.categories.count)
        let selectedCategory = factory.categories[selectedCategoryIndex]
        categoryButton.setSecondaryLable(text: selectedCategory.categoryName)
        categoryIsSelected = true
    }
    
    @objc private func scheduleButtonPressed() {
        let nextController = ScheduleController(with: schedule)
        nextController.delegate = self
        present(nextController, animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonPressed() {
        let newTracker = Tracker(id: UUID(),
                                 name: userInput,
                                 // заглушка для цвета и эмоджи
                                 color: Int.random(in: 0...17),
                                 emoji: Int.random(in: 0...17),
                                 schedule: schedule)
        delegate?.configTypeControllerController(self, didFilledTracker: newTracker, for: selectedCategoryIndex)
    }
    
    private func updateCreateButtonState() {
        createButton.backgroundColor = formIsFulfilled ? .ypBlack : .ypGray
        createButton.isEnabled = formIsFulfilled ? true : false
    }
    
    private func chekConfigState() {
        formIsFulfilled = trackerNameIsFulfilled && categoryIsSelected && scheduleIsFulfilled
        && emojiIsSelected && colorIsSelected
    }
    
    private func fetchSchedule(from schedule: [Bool]) {
        self.schedule = schedule
        let days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        let fullWeek = [true, true, true, true, true, true, true]
        let workDays = [true, true, true, true, true, false, false]
        let weekends = [false, false, false, false, false, true, true]
        var finalSchadule: [String] = []
        switch schedule {
        case fullWeek:
            scheduleButton.setSecondaryLable(text: "Каждый день")
        case workDays:
            scheduleButton.setSecondaryLable(text: "Будни")
        case weekends:
            scheduleButton.setSecondaryLable(text: "Выходные")
        default:
            for index in 0..<schedule.count where schedule[index] {
                finalSchadule.append(days[index])
            }
            let finalSchaduleWithSeparation = finalSchadule.joined(separator: ", ")
            scheduleButton.setSecondaryLable(text: finalSchaduleWithSeparation)
        }
        scheduleIsFulfilled = true
    }
}

// MARK: - UITextFieldDelegate

extension ConfigTypeController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        userInput = textField.text ?? ""
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        if newLength >= textFieldLimit {
            warningLabel.isHidden = false
        } else {
            warningLabel.isHidden = true
        }
        return newLength <= textFieldLimit
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

extension ConfigTypeController: ScheduleControllerDelegate {
    func scheduleController(_ viewController: ScheduleController, didSelectSchedule schedule: [Bool]) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchSchedule(from: schedule)
        }
    }
}

// MARK: - UI Configuration

private extension ConfigTypeController {
    // MARK: - SetupUI
    
    func setupUI() {
        setTitle()
        setTitle()
        setupTextField()
        setupSettings()
        setupButtons()
    }
    
    // MARK: - Title Lable config
    func setTitle() {
        view.addSubview(titleLabel)
        setTitleConstraits()
    }
    func setTitleConstraits() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: titleSpacing),
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
            titleTextField.heightAnchor.constraint(equalToConstant: settingHeight)
        ])
    }
    
    func setWarningLabelConstraints() {
        NSLayoutConstraint.activate([
            warningLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            warningLabel.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            warningLabel.heightAnchor.constraint(equalToConstant: settingHeight / 2)
        ])
    }
    
    func setTextFieldStackViewConstraints() {
        NSLayoutConstraint.activate([
            textFieldStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingSpacing),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -leadingSpacing),
            textFieldStackView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: bottomSpacing)
        ])
    }
    
    //MARK: - settings fields config
    
    func setupSettings() {
        view.addSubview(settingsView)
        configSettingsConstraints()
        settingsView.addSubview(categoryButton)
        if isHabit {
            let separator = Separators()
            separator.addSeparators(for: settingsView, width: settingsViewWidth - leadingSpacing * 2, times: 1)
            settingsView.addSubview(scheduleButton)
        }
    }
    
    func configSettingsConstraints() {
        NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingSpacing),
            settingsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -leadingSpacing),
            settingsView.heightAnchor.constraint(equalToConstant: settingsViewHeight),
            settingsView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: bottomSpacing)
        ])
    }
    
    //MARK: - buttons config
    
    func setupButtons() {
        view.addSubview(buttonsStackView)
        updateCreateButtonState()
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        configButtonsConstraints()
    }
    
    func configButtonsConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: buttonViewWidth),
            buttonsStackView.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonsStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -leadingSpacing
            )
        ])
    }
}
