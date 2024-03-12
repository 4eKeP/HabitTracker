//
//  EditTrackerController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 10.03.2024.
//

import UIKit

protocol EditTrackerControllerDelegate: AnyObject {
    func editTrackerControllerController(_ viewController: EditTrackerController, didChangedTracker tracker: Tracker, for categoryIndex: UUID)
}

final class EditTrackerController: UIViewController {
    
    private let titleLabelTextNewHabit = Resources.ConfigTypeConstants.Labels.titleLabelTextNewHabit
    
    private let titleLabelTextNewEvent = Resources.ConfigTypeConstants.Labels.titleLabelTextNewEvent
    
    private let titleTextFieldPlaceholder = Resources.ConfigTypeConstants.Labels.titleTextFieldPlaceholder
    
    private let warningLabelText = Resources.ConfigTypeConstants.Labels.warningLabelText
    
    private let categoryButtonText = Resources.ConfigTypeConstants.Labels.categoryButtonText
    
    private let scheduleButtonText = Resources.ConfigTypeConstants.Labels.scheduleButtonText
    
    private let cancelButtonText = Resources.ConfigTypeConstants.Labels.cancelButtonText
    
    private let saveButtonText = Resources.ConfigTypeConstants.Labels.saveButtonText
    
    private let fullWeekText = Resources.ConfigTypeConstants.Labels.fullWeekText
    
    private let workDaysText = Resources.ConfigTypeConstants.Labels.workDaysText
    
    private let weekendsText = Resources.ConfigTypeConstants.Labels.weekendsText
    
    private let collectionTypeEmojiText = Resources.ConfigTypeConstants.Labels.collectionTypeEmojiText
    
    private let collectionTypeColorText = Resources.ConfigTypeConstants.Labels.collectionTypeColorText
    
    private let shortWeekDays = Resources.ConfigTypeConstants.Labels.shortWeekDays
    
    private lazy var settingsViewWidth: CGFloat = {
        view.frame.width - 2 * leadingSpacing
    }()
    
    private lazy var settingsViewHeight: CGFloat = {
        settingHeight * 2
    }()
    
    private lazy var buttonViewWidth: CGFloat = {
        view.frame.width - 2 * leadingButton
    }()
    
    private let leadingButton: CGFloat = Resources.ConfigTypeConstants.leadingButton
    
    private let leadingSpacing: CGFloat = Resources.ConfigTypeConstants.leadingSpacing
    
    private let settingHeight: CGFloat = Resources.ConfigTypeConstants.settingHeight
    
    private let titleSpacing: CGFloat = Resources.ConfigTypeConstants.titleSpacing
    
    private let bottomSpacing: CGFloat = Resources.ConfigTypeConstants.bottomSpacing
    
    private let buttonHeight: CGFloat = Resources.ConfigTypeConstants.buttonHeight
    
    private let settingsSectionHeight: CGFloat = Resources.ConfigTypeConstants.settingsSectionHeight
    
    private let configCollectionCellHeight: CGFloat = Resources.ConfigTypeConstants.configCollectionCellHeight
    
    private let configCellsPerLine: CGFloat = Resources.ConfigTypeConstants.configCellsPerLine
    
    private let configHeight: CGFloat = Resources.ConfigTypeConstants.configHeight
    
    private lazy var scrollViewHeight: CGFloat = Resources.ConfigTypeConstants.scrollViewHeight
    
    private lazy var isRTL = UIView.userInterfaceLayoutDirection(for: titleLabel.semanticContentAttribute) == .rightToLeft
    
    private lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.text = Resources.ConfigTypeConstants.Labels.editHabit
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var counterLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Counter of total tracker's completed days"),
            self.editModel.counter
        )
        return label
    }()
    
    private lazy var titleTextField = {
        let textField = UITextField()
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        textField.leftViewMode = .always
        textField.leftView = spacer
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.placeholder = titleTextFieldPlaceholder
        textField.clearButtonMode = .whileEditing
        textField.textColor = .ypBlack
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var warningLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = warningLabelText
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
        button.setPrimaryLable(text: categoryButtonText)
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
        button.setPrimaryLable(text: scheduleButtonText)
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
        button.setTitle(cancelButtonText, for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton = {
        let button = TypeButton()
        button.setTitle(saveButtonText, for: .normal)
        button.setTitleColor(.ypLightGray, for: .disabled)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
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
    
    private var schedule: [Bool]
    
    private let textFieldLimit = 38
    
    private var trackerNameIsFulfilled: Bool {
        !userInput.isEmpty
    }
    
    private var selectedCategoryIndex: UUID
    
    private var emojiIndex: Int
    
    private var colorIndex: Int
    
    private var userInput: String {
        didSet {
            updateSaveButtonState()
        }
    }
    
    private let factory = TrackersFactoryCD.shared
    
    private var editModel: TrackerForEdit
    
    weak var delegate: EditTrackerControllerDelegate?
    
    init(trackerForEdit editModel: TrackerForEdit) {
        self.editModel = editModel
        self.colorIndex = editModel.tracker.color
        self.emojiIndex = editModel.tracker.emoji
        self.schedule = editModel.tracker.schedule
        self.userInput = editModel.tracker.name
        self.selectedCategoryIndex = editModel.category.id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupUI()
        setupState()
        titleTextField.delegate = self
        titleTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            let emojiIndexPath = IndexPath(item: self.editModel.tracker.emoji, section: 0)
            self.emojiCollection.selectItem(at: emojiIndexPath, animated: true, scrollPosition: .left)
            self.emojiCollection.cellForItem(at: emojiIndexPath)?.backgroundColor = .ypLightGray
            
            let colorIndexPath = IndexPath(item: self.editModel.tracker.color, section: 0)
            self.colorCollection.selectItem(at: colorIndexPath, animated: true, scrollPosition: .left)
            self.colorCollection.cellForItem(at: colorIndexPath)?
                .backgroundColor = Resources.colors[self.editModel.tracker.color].withAlphaComponent(0.3)
        }
    }
    
    @objc private func categoryButtonPressed() {
        let viewModel = CategoryViewModel(selectedCategoryID: selectedCategoryIndex)
        let nextController = CategoryViewController(viewModel: viewModel)
        viewModel.delegate = self
        present(nextController, animated: true)
    }
    
    @objc private func scheduleButtonPressed() {
        let nextController = ScheduleController(with: schedule)
        nextController.delegate = self
        present(nextController, animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonPressed() {
        let updatedTracker = Tracker(id: editModel.tracker.id,
                                     name: userInput,
                                     color: colorIndex,
                                     emoji: emojiIndex,
                                     schedule: schedule,
                                     isPinned: editModel.tracker.isPinned)
        delegate?.editTrackerControllerController(self, didChangedTracker: updatedTracker, for: selectedCategoryIndex)
    }
    
    private func updateSaveButtonState() {
        saveButton.backgroundColor = trackerNameIsFulfilled ? .ypBlack : .ypGray
        saveButton.isEnabled = trackerNameIsFulfilled ? true : false
    }
    
    private func fetchSchedule(from schedule: [Bool]) {
        self.schedule = schedule
        let fullWeek = [true, true, true, true, true, true, true]
        let workDays = [true, true, true, true, true, false, false]
        let weekends = [false, false, false, false, false, true, true]
        switch schedule {
        case fullWeek:
            scheduleButton.setSecondaryLable(text: fullWeekText)
        case workDays:
            scheduleButton.setSecondaryLable(text: workDaysText)
        case weekends:
            scheduleButton.setSecondaryLable(text: weekendsText)
        default:
            var finalSchadule: [String] = []
            for index in 0..<schedule.count where schedule[index] {
                finalSchadule.append(shortWeekDays[index])
            }
            let finalSchaduleWithSeparation = finalSchadule.joined(separator: ", ")
            scheduleButton.setSecondaryLable(text: finalSchaduleWithSeparation)
        }
    }
    
    func fetchCategory(from category: TrackerCategory) {
        selectedCategoryIndex = category.id
        categoryButton.setSecondaryLable(text: category.categoryName)
    }
    
    func setupState() {
        titleTextField.text = editModel.tracker.name
        fetchSchedule(from: editModel.tracker.schedule)
        fetchCategory(from: editModel.category)
    }
}

//MARK: - CategoryViewControllerDelegate

extension EditTrackerController: CategoryViewControllerDelegate {
    func categoryViewController(_ viewController: CategoryViewController, select category: TrackerCategory) {
        dismiss(animated: true) {
            [weak self] in
            guard let self = self else { return }
            self.fetchCategory(from: category)
        }
    }
}

// MARK: - UITextFieldDelegate

extension EditTrackerController: UITextFieldDelegate {
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
        userInput = textField.text ?? ""
        return true
    }
}

//MARK: - ScheduleControllerDelegate

extension EditTrackerController: ScheduleControllerDelegate {
    func scheduleController(_ viewController: ScheduleController, didSelectSchedule schedule: [Bool]) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchSchedule(from: schedule)
        }
    }
}

// MARK: - UICollection Data Source
extension EditTrackerController: UICollectionViewDataSource {
    
    private enum CollectionType {
        static let emoji = 0
        static let color = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case CollectionType.emoji:
            return Resources.emojis.count
        case CollectionType.color:
            return Resources.colors.count
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
            cell.configEmojiCell(emoji: Resources.emojis[indexPath.item])
            return cell
        case CollectionType.color:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.Identifer, for: indexPath) as? ColorCell else {
                assertionFailure("не удалось получить ColorCell")
                return UICollectionViewCell()
            }
            cell.backgroundColor = .ypWhite
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            cell.configColorCell(color: Resources.colors[indexPath.row])
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
            view.config(header: collectionTypeEmojiText)
        case CollectionType.color:
            view.config(header: collectionTypeColorText)
        default:
            break
        }
        return view
    }
}

// MARK: - UICollection Delegate

extension EditTrackerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case CollectionType.emoji:
            emojiIndex = indexPath.row
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .ypLightGray
        case CollectionType.color:
            colorIndex = indexPath.row
            collectionView.cellForItem(at: indexPath)?.backgroundColor = Resources.colors[colorIndex].withAlphaComponent(0.3)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = .ypWhite
    }
}

// MARK: - UICollection FlowLayout

extension EditTrackerController: UICollectionViewDelegateFlowLayout {
    
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

private extension EditTrackerController {
    // MARK: - SetupUI
    func setupUI() {
        view.backgroundColor = .ypWhite
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
        view.addSubview(counterLabel)
        setTitleConstraits()
    }
    func setTitleConstraits() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: titleSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            counterLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: bottomSpacing),
            counterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            counterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
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
            contentScrollView.topAnchor.constraint(equalTo: counterLabel.bottomAnchor),
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
        configRTLTextField()
        textFieldStackView.addArrangedSubview(titleTextField)
        textFieldStackView.addArrangedSubview(warningLabel)
        setTitleTextFieldConstraints()
        setWarningLabelConstraints()
        setTextFieldStackViewConstraints()
    }
    
    func configRTLTextField() {
        titleTextField.textAlignment = isRTL ? .right : .natural
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
        let separator = Separators()
        separator.addSeparators(for: settingsView, width: settingsViewWidth - leadingSpacing * 2, times: 1)
        settingsView.addSubview(scheduleButton)
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
        updateSaveButtonState()
        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(saveButton)
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
