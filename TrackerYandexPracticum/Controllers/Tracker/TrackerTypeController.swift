//
//  TrackerTypeController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 05.12.2023.
//

import UIKit

protocol TrackerTypeControllerDelegate: AnyObject {
    func trackerTypeController(_ viewController: TrackerTypeController, didFillTracker tracker: Tracker, for categoryIndex: UUID)
}

final class TrackerTypeController: UIViewController {
    
    private let titleLabelText = Resources.TrackerTypeConstants.Labels.titleLabelText
    
    private let addHabitButtonText = Resources.TrackerTypeConstants.Labels.addHabitButtonText
    
    private let addEventButtonText = Resources.TrackerTypeConstants.Labels.addEventButtonText
    
    private let analyticService = AnalyticService()
    
    private lazy var titleLabel = {
        let titleLable = UILabel()
        titleLable.text = titleLabelText
        titleLable.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        return titleLable
    }()
    
    private lazy var stackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let leadingButton: CGFloat = Resources.TrackerTypeConstants.leadingButton
    
    private let buttonHeight: CGFloat = Resources.TrackerTypeConstants.buttonHeight
    
    private let buttonSpacing: CGFloat = Resources.TrackerTypeConstants.buttonSpacing
    
    weak var delegate: TrackerTypeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupTitle()
        setupStackView()
    }
    
    @objc func habitButtonPressed() {
        analyticService.report(name: "click", parameters: ["screen": "new", "item": "habit"])
        let nextController = ConfigTypeController(isHabit: true)
        nextController.delegate = self
        present(nextController, animated: true)
    }
    
    @objc func eventButtonPressed() {
        analyticService.report(name: "click", parameters: ["screen": "new", "item": "event"])
        let nextController = ConfigTypeController(isHabit: false)
        nextController.delegate = self
        present(nextController, animated: true)
    }
}

extension TrackerTypeController: ConfigTypeControllerDelegate {
    func configTypeControllerController(_ viewController: ConfigTypeController, didFilledTracker tracker: Tracker, for categoryIndex: UUID) {
        delegate?.trackerTypeController(self, didFillTracker: tracker, for: categoryIndex)
    }
}


// MARK: - View configuration

private extension TrackerTypeController {
    //MARK: Title configuration
    func setupTitle() {
        view.addSubview(titleLabel)
        setTitleConstraints()
    }
    
    func setTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    //MARK: stackView configuration
    
    func setupStackView() {
        view.addSubview(stackView)
        addStackViewConstarints()
        addHabitButton()
        addEventButton()
    }
    
    func addHabitButton() {
        let HabitButton = TypeButton()
        HabitButton.setTitle(addHabitButtonText, for: .normal)
        HabitButton.addTarget(self, action: #selector(habitButtonPressed), for: .touchUpInside)
        stackView.addArrangedSubview(HabitButton)
    }
    
    func addEventButton() {
        let EventButton = TypeButton()
        EventButton.setTitle(addEventButtonText, for: .normal)
        EventButton.addTarget(self, action: #selector(eventButtonPressed), for: .touchUpInside)
        stackView.addArrangedSubview(EventButton)
    }
    
    func addStackViewConstarints() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: view.frame.width - 2 * leadingButton),
            stackView.heightAnchor.constraint(equalToConstant: 2 * buttonHeight + buttonSpacing)
        ])
    }
    
}
