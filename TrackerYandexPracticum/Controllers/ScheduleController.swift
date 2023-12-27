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
    
    private lazy var headerLable = {
        let lable = UILabel()
        lable.text = "Расписание"
        lable.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lable.textAlignment = .center
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        return lable
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
        button.setTitle("Готово", for: .normal)
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
    
    private let switchWidth: CGFloat = Constants.ScheduleConstants.switchWidth
    
    private let switchHeight: CGFloat = Constants.ScheduleConstants.switchHeight
    
    private let leadingSpacing: CGFloat = Constants.ScheduleConstants.leadingSpacing
    
    private let switchFieldHeight: CGFloat = Constants.ScheduleConstants.switchFieldHeight
    
    private let spacing: CGFloat = Constants.ScheduleConstants.spacing
    
    private let titleSpacing: CGFloat = Constants.ScheduleConstants.titleSpacing
    
    private let bottomSpacing: CGFloat = Constants.ScheduleConstants.bottomSpacing
    
    private let buttonHeight: CGFloat = Constants.ScheduleConstants.buttonHeight
    
    private let numberOfDays = 7
    private let daysName = [
        "Понедельник",
        "Вторник",
        "Среда",
        "Четверг",
        "Пятница",
        "Суббота",
        "Воскресенье"
    ]
    
    private lazy var formIsFulfilled = false {
        didSet {
            updateDoneButtonState()
        }
    }
    
    private let cellIdentifier = "cell"
    
    private var schedule: [Bool]
    
    weak var delegate: ScheduleControllerDelegate?
    
    init(with schadule: [Bool]) {
        self.schedule = schadule
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
        view.addSubview(headerLable)
        configHeaderConstraints()
    }
    
    func configHeaderConstraints() {
        NSLayoutConstraint.activate([
            headerLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: titleSpacing),
            headerLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    
    //MARK: Switch config
    
    func setupSwitch() {
        view.addSubview(scheduleView)
        configScheduleViewConstraints()
        for day in 0..<numberOfDays {
            configSwitchLable(index: day)
            configSwitch(index: day)
        }
        let separator = Separators()
        separator.addSeparators(for: scheduleView,
                                width: scheduleViewWidth - spacing * 2,
                                times: numberOfDays - 1)
    }
    
    func configSwitchLable(index: Int) {
        let lable = UILabel()
        lable.textColor = .ypBlack
        lable.text = daysName[index]
        lable.textAlignment = .natural
        
        lable.frame = CGRect(x: leadingSpacing,
                             y: switchFieldHeight * CGFloat(index),
                             width: scheduleViewWidth,
                             height: switchFieldHeight)
        scheduleView.addSubview(lable)
    }
    
    func configSwitch(index: Int) {
        let daySwitch = UISwitch()
        daySwitch.isOn = schedule[index]
        daySwitch.tag = index
        daySwitch.thumbTintColor = .ypWhite
        daySwitch.onTintColor = .ypBlue
        daySwitch.addTarget(self, action: #selector(switchPressed(_:)), for: .touchUpInside)
        daySwitch.frame = CGRect(x: scheduleViewWidth - spacing - switchWidth,
                                 y: switchFieldHeight * CGFloat(index) + switchHeight,
                                 width: switchWidth,
                                 height: switchHeight)
        scheduleView.addSubview(daySwitch)
    }
    
    func configScheduleViewConstraints() {
        NSLayoutConstraint.activate([
            scheduleView.topAnchor.constraint(equalTo: headerLable.bottomAnchor, constant: bottomSpacing),
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

