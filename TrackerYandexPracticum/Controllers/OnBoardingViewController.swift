//
//  OnBoardingController.swift
//  TrackerYandexPracticum
//
//  Created by admin on 09.01.2024.
//

import UIKit

final class OnBoardingController: UIPageViewController {
    
    private let leadingOnBoardingPage = Resources.OnBoardingControllerConstants.leadingOnBoardingPage
    private let centerOffsetOrButtonHeight = Resources.OnBoardingControllerConstants.centerOffsetOrButtonHeight
    private let bottomSpacing = Resources.OnBoardingControllerConstants.bottomSpacing
    private let bottomPageControllOffset = Resources.OnBoardingControllerConstants.bottomPageControllOffset
    
    private let blueControllerText = Resources.OnBoardingControllerConstants.Labels.blueControllerText
    
    private let redControllerText = Resources.OnBoardingControllerConstants.Labels.redControllerText
    
    private let buttonTitleText = Resources.OnBoardingControllerConstants.Labels.buttonTitleText
    
    private let bluePageController = UIViewController()
    private let redPageController = UIViewController()
    
    private lazy var pages: [UIViewController] = [bluePageController, redPageController]
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    //MARK: - Init
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControllers()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        setupPageControl()
    }
    
    @objc private func buttonPressed() {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowsScenes = scenes.first as? UIWindowScene,
              let window = windowsScenes.windows.first
        else { return assertionFailure("Не удалось получить window в PageControl")}
        let viewController = TabBarController()
        UserDefaults.standard.isOnBoarded = true
        window.rootViewController = viewController
    }
}

//MARK: - UIPageViewControllerDataSource

extension OnBoardingController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = vcIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

//MARK: - UIPageViewControllerDelegate

extension OnBoardingController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

//MARK: - UI configuration
private extension OnBoardingController {
    
    func setupControllers() {
        addBackgroundImage(UIImage(named: "OnboardingPage1"), to: bluePageController.view)
        addTitle(blueControllerText, to: bluePageController.view)
        addButton(to: bluePageController.view)
        
        addBackgroundImage(UIImage(named: "OnboardingPage2"), to: redPageController.view)
        addTitle(redControllerText, to: redPageController.view)
        addButton(to: redPageController.view)
    }
    
    func addBackgroundImage(_ image: UIImage?, to view: UIView) {
        let imageView = UIImageView()
        
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addTitle(_ title: String, to view: UIView) {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.text = title
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingOnBoardingPage),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingOnBoardingPage),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: centerOffsetOrButtonHeight),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func addButton(to view: UIView) {
        let button = TypeButton()
        
        button.setTitle(buttonTitleText, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingOnBoardingPage),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingOnBoardingPage),
            button.heightAnchor.constraint(equalToConstant: centerOffsetOrButtonHeight),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSpacing)
        ])
    }
    
    func setupPageControl() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomPageControllOffset)
        ])
    }
}
