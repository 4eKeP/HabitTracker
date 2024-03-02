//
//  ScheduleController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 09.12.2023.
//

import UIKit


protocol ScheduleControllerDelegate: AnyObject {
    func scheduleController(_ viewController: ScheduleController, didSelectSchedule schedule: [Bool])
}

final class ScheduleController: UIViewController {
    
    private let headerText = Resources.ScheduleConstants.Labels.headerText
    
    private let doneButtonText = Resources.ScheduleConstants.Labels.doneButtonText
    
    private lazy var headerLabel = {
        let label = UILabel()
        label.text = headerText
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        return label
    }()
    
    private lazy var scheduleView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: scheduleViewWidth, height: scheduleViewHeight)
        return view
    }()
    
    private lazy var doneButton = {
        let button = TypeButton()
        button.setTitle(doneButtonText, for: .normal)
        button.setTitleColor(.ypLightGray, for: .disabled)
        button.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scheduleViewWidth: CGFloat = {
        view.frame.width - 32
    }()
    
    private lazy var scheduleViewHeight: CGFloat = {
        return switchFieldHeight * CGFloat(numberOfDays)
    }()
    
    private lazy var buttonWidth: CGFloat = {
        view.frame.width - 40
    }()
    
    private let switchWidth: CGFloat = Resources.ScheduleConstants.switchWidth
    
    private let switchHeight: CGFloat = Resources.ScheduleConstants.switchHeight
    
    private let leadingSpacing: CGFloat = Resources.ScheduleConstants.leadingSpacing
    
    private let switchFieldHeight: CGFloat = Resources.ScheduleConstants.switchFieldHeight
    
    private let spacing: CGFloat = Resources.ScheduleConstants.spacing
    
    private let titleSpacing: CGFloat = Resources.ScheduleConstants.titleSpacing
    
    private let bottomSpacing: CGFloat = Resources.ScheduleConstants.bottomSpacing
    
    private let buttonHeight: CGFloat = Resources.ScheduleConstants.buttonHeight
    
    private let numberOfDays = Calendar.autoupdatingCurrent.weekdaySymbols.count
    private let daysName = Calendar.autoupdatingCurrent.weekdaySymbols.shift()
    
    private lazy var formIsFulfilled = false {
        didSet {
            updateDoneButtonState()
        }
    }
    
    private lazy var isRTL = UIView.userInterfaceLayoutDirection(for: headerLabel.semanticContentAttribute) == .rightToLeft
    
    private var schedule: [Bool]
    
    weak var delegate: ScheduleControllerDelegate?
    
    init(with schedule: [Bool]) {
        self.schedule = schedule
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupUI()
    }
    
    @objc private func switchPressed(_ sender: UISwitch) {
        schedule[sender.tag] = sender.isOn
        updateFormState()
    }
    
    @objc private func doneButtonClicked() {
        delegate?.scheduleController(self, didSelectSchedule: schedule)
    }
    
    private func updateDoneButtonState() {
        doneButton.backgroundColor = formIsFulfilled ? .ypBlack : .ypGray
        doneButton.isEnabled = formIsFulfilled ? true : false
    }
    
    private func updateFormState() {
        formIsFulfilled = !schedule.filter { $0 == true }.isEmpty
    }
}

//MARK: UI configuration

private extension ScheduleController {
    
    func setupUI() {
        setupHeader()
        setupSwitch()
        setupButton()
    }
    
    //MARK: Header config
    func setupHeader() {
        view.addSubview(headerLabel)
        configHeaderConstraints()
    }
    
    func configHeaderConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: titleSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    
    //MARK: Switch config
    
    func setupSwitch() {
        view.addSubview(scheduleView)
        configScheduleViewConstraints()
        for day in 0..<numberOfDays {
            configSwitchLabel(index: day)
            configSwitch(index: day)
        }
        let separator = Separators()
        separator.addSeparators(for: scheduleView,
                                width: scheduleViewWidth - spacing * 2,
                                times: numberOfDays - 1)
    }
    
    func configSwitchLabel(index: Int) {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = daysName[index]
        label.textAlignment = .natural
        
        label.frame = CGRect(x: isRTL ? -leadingSpacing : leadingSpacing,
                             y: switchFieldHeight * CGFloat(index),
                             width: scheduleViewWidth,
                             height: switchFieldHeight)
        scheduleView.addSubview(label)
    }
    
    func configSwitch(index: Int) {
        let daySwitch = UISwitch()
        daySwitch.isOn = schedule[index]
        daySwitch.tag = index
        daySwitch.thumbTintColor = .ypWhite
        daySwitch.onTintColor = .ypBlue
        daySwitch.addTarget(self, action: #selector(switchPressed(_:)), for: .touchUpInside)
        daySwitch.frame = CGRect(x: isRTL ? leadingSpacing : scheduleViewWidth - spacing - switchWidth,
                                 y: switchFieldHeight * CGFloat(index) + switchHeight,
                                 width: switchWidth,
                                 height: switchHeight)
        scheduleView.addSubview(daySwitch)
    }
    
    func configScheduleViewConstraints() {
        NSLayoutConstraint.activate([
            scheduleView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: bottomSpacing),
            scheduleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            scheduleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
            scheduleView.heightAnchor.constraint(equalToConstant: scheduleViewHeight)
        ])
    }
    
    //MARK: Button config
    
    func setupButton() {
        updateDoneButtonState()
        updateFormState()
        view.addSubview(doneButton)
        configDoneButtonConstraints()
    }
    
    func configDoneButtonConstraints() {
        NSLayoutConstraint.activate([
            doneButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            doneButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            doneButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -spacing)
        ])
    }
}

