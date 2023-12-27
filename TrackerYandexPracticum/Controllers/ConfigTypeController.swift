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
    
    private let leadingButton: CGFloat = Constants.ConfigTypeConstants.leadingButton
    
    private let leadingSpacing: CGFloat = Constants.ConfigTypeConstants.leadingSpacing
    
    private let settingHeight: CGFloat = Constants.ConfigTypeConstants.settingHeight
    
    private let titleSpacing: CGFloat = Constants.ConfigTypeConstants.titleSpacing
    
    private let bottomSpacing: CGFloat = Constants.ConfigTypeConstants.bottomSpacing
    
    private let buttonHeight: CGFloat = Constants.ConfigTypeConstants.buttonHeight
    
    private let settingsSectionHeight: CGFloat = Constants.ConfigTypeConstants.settingsSectionHeight
    
    private let configCollectionCellHeight: CGFloat = Constants.ConfigTypeConstants.configCollectionCellHeight
    
    private let configCellsPerLine: CGFloat = Constants.ConfigTypeConstants.configCellsPerLine
    
    private let configHeight: CGFloat = Constants.ConfigTypeConstants.configHeight
    
    private lazy var scrollViewHeight: CGFloat = Constants.ConfigTypeConstants.scrollViewHeight
    
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
    //MARK: переделать секции
    private lazy var emojiCollection = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.Identifer)
        collection.register(ConfigHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ConfigHeader.Identifer)
        return collection
    }()
    
    private lazy var colorCollection = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.Identifer)
        collection.register(ConfigHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ConfigHeader.Identifer)
        return collection
    }()
    
    private lazy var contentScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: view.frame.width,
                                        height: scrollViewHeight)
        return scrollView
    }()
    
    private lazy var contentStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = bottomSpacing
        return stackView
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
    private var emojiIsSelected = false {
        didSet {
            chekConfigState()
        }
    }
    private var colorIsSelected = false {
        didSet {
            chekConfigState()
        }
    }
    
    //MARK: На будущее сделать из isHabit энум что бы легче добавлять новые типы привычек
    private var isHabit: Bool
    
    private var selectedCategoryIndex = 0 {
        didSet {
            trackerNameIsFulfilled = true
        }
    }
    
    private var emojiIndex = 0 {
        didSet {
            emojiIsSelected = true
        }
    }
    
    private var colorIndex = 0 {
        didSet {
            colorIsSelected = true
        }
    }
    
    private var userInput = "" {
        didSet {
            trackerNameIsFulfilled = true
        }
    }
    
    private let factory = TrackersFactoryCD.shared
    
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
        selectedCategoryIndex = Int.random(in: 0..<factory.countCategories())
        categoryButton.setSecondaryLable(text: factory.fetchCategoryName(by: selectedCategoryIndex))
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
                                 color: colorIndex,
                                 emoji: emojiIndex,
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

// MARK: - UICollection Data Source
extension ConfigTypeController: UICollectionViewDataSource {
    
    private enum CollectionType {
        static let emoji = 0
        static let color = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case CollectionType.emoji:
            return Constants.emojis.count
        case CollectionType.color:
            return Constants.colors.count
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case CollectionType.emoji:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.Identifer, for: indexPath) as? EmojiCell else {
                assertionFailure("не удалось получить EmojiCell")
                return UICollectionViewCell()
            }
            cell.backgroundColor = .ypWhite
            cell.layer.cornerRadius = 16
            cell.layer.masksToBounds = true
            cell.configEmojiCell(emoji: Constants.emojis[indexPath.row])
            return cell
        case CollectionType.color:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.Identifer, for: indexPath) as? ColorCell else {
                assertionFailure("не удалось получить ColorCell")
                return UICollectionViewCell()
            }
            cell.backgroundColor = .ypWhite
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.configColorCell(color: Constants.colors[indexPath.row])
            return cell
        default:
            assertionFailure("не удалось получить tag ячейки")
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = ConfigHeader.Identifer
        default:
            id = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? ConfigHeader else {
            assertionFailure("не удалось получить ConfigHeader")
            return ConfigHeader()
        }
        switch collectionView.tag {
        case CollectionType.emoji:
            view.config(header: "Emoji")
        case CollectionType.color:
            view.config(header: "Цвет")
        default:
            break
        }
        return view
    }
}

// MARK: - UICollection Delegate

extension ConfigTypeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case CollectionType.emoji:
            emojiIndex = indexPath.row
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .ypLightGray
        case CollectionType.color:
            colorIndex = indexPath.row
            collectionView.cellForItem(at: indexPath)?.backgroundColor = Constants.colors[colorIndex].withAlphaComponent(0.3)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .ypWhite
    }
}

// MARK: - UICollection FlowLayout

extension ConfigTypeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: configCollectionCellHeight,
               height: configCollectionCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let cellsPerLine = configCellsPerLine
        let totalCellsWidth = configCellsPerLine * configCollectionCellHeight
        return (collectionView.frame.width - 2 * leadingSpacing - totalCellsWidth) / (cellsPerLine - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView.tag {
        case 1:
            return 5
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width,
               height: configHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: leadingSpacing,
                     left: leadingSpacing,
                     bottom: leadingSpacing,
                     right: leadingSpacing)
    }
}

// MARK: - UI Configuration

private extension ConfigTypeController {
    // MARK: - SetupUI
    // MARK: разобраться с порядком констрейнтов
    func setupUI() {
        setTitle()
        setupScrollView()
        setupTextField()
        setupSettings()
        setupEmojiCollection()
        setupColorCollection()
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
    
    // MARK: - contentView config
    
    func setupScrollView() {
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentStackView)
        configScrollViewConstraints()
    }
    
    func configScrollViewConstraints() {
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configStackViewConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor)
        ])
    }
    
    // MARK: - textField config
    
    func setupTextField() {
        contentStackView.addArrangedSubview(textFieldStackView)
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
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingSpacing),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingSpacing),
            textFieldStackView.topAnchor.constraint(
                equalTo: contentStackView.topAnchor,
                constant: bottomSpacing)
        ])
    }
    
    //MARK: - settings fields config
    
    func setupSettings() {
        contentStackView.addArrangedSubview(settingsView)
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
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingSpacing),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingSpacing),
            settingsView.heightAnchor.constraint(equalToConstant: settingsViewHeight),
        ])
    }
    
    //MARK: - emoji config
    func setupEmojiCollection() {
        configEmojiCollection()
        contentStackView.addArrangedSubview(emojiCollection)
        configEmojiCollectionConstraints()
    }
    
    func configEmojiCollection() {
        emojiCollection.dataSource = self
        emojiCollection.delegate = self
        emojiCollection.tag = 0
        emojiCollection.isScrollEnabled = false
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configEmojiCollectionConstraints() {
        NSLayoutConstraint.activate([
            emojiCollection.heightAnchor.constraint(equalToConstant: settingsSectionHeight),
            emojiCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    //MARK: - color config
    
    func setupColorCollection() {
        configColorCollection()
        contentStackView.addArrangedSubview(colorCollection)
        configColorCollectionConstraints()
    }
    
    func configColorCollection() {
        colorCollection.dataSource = self
        colorCollection.delegate = self
        colorCollection.tag = 1
        colorCollection.isScrollEnabled = false
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configColorCollectionConstraints() {
        NSLayoutConstraint.activate([
            colorCollection.heightAnchor.constraint(equalToConstant: settingsSectionHeight),
            colorCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    //MARK: - buttons config
    
    func setupButtons() {
        contentStackView.addArrangedSubview(buttonsStackView)
        updateCreateButtonState()
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(createButton)
        configButtonsConstraints()
    }
    
    func configButtonsConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.widthAnchor.constraint(equalToConstant: buttonViewWidth),
            buttonsStackView.heightAnchor.constraint(equalToConstant: buttonHeight),
            buttonsStackView.bottomAnchor.constraint(
                equalTo: contentStackView.bottomAnchor,
                constant: -leadingSpacing
            )
        ])
    }
}
