//
//  OnboardingViewController.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 4/13/25.
//

import UIKit

import RxCocoa
import RxSwift
import SideMenu
import SnapKit
import Then

final class OnboardingViewController: BaseViewController {
    
    private let viewModel = OnboardingViewModel()
    private let disposeBag = DisposeBag()
    private var currentPageIndex = 0
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private let pageControl = UIPageControl()
    private let skipButton = UIButton(type: .system)
    private let nextButton = UIButton(type: .system)
    private let startButton = UIButton(type: .system)
    
    // 온보딩 페이지 데이터
    private let pages: [OnboardingPageViewController] = [
        OnboardingPageViewController(
            image: ImageLiterals.horizentalLogo,
            title: "성지슐랭에 오신 것을 환영합니다!",
            description: "유명인과 주인장이 추천하는\n 숨겨진 맛집을 찾아 떠나볼까요? 🔎"
        ),
        OnboardingPageViewController(
            image: ImageLiterals.mapFill,
            title: "지도로 쉽게 맛집 탐색",
            description: "유명인 추천 맛집을 지도에서\n 한눈에 확인하고 방문해보세요! 🚗"
        ),
        OnboardingPageViewController(
            image: ImageLiterals.bookmarkFill,
            title: "나만의 맛집 컬렉션",
            description: "방문한 곳과 마음에 드는 맛집을 저장하고,\n언제든 다시 찾아가세요! 📌"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        bind()
    }
    
    // MARK: - Setup
    override func setHierarchy() {
        view.addSubviews(
            pageViewController.view,
            pageControl,
            skipButton,
            nextButton,
            startButton
        )
    }
    
    override func setLayout() {
        pageViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(pageControl.snp.top).offset(-20)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        skipButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
        
        startButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(50)
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .bg100
        
        pageControl.do {
            $0.numberOfPages = pages.count
            $0.currentPage = 0
            $0.pageIndicatorTintColor = .bg300
            $0.currentPageIndicatorTintColor = .primary200
        }
        
        skipButton.do {
            $0.setTitle("건너뛰기", for: .normal)
            $0.setTitleColor(.primary200, for: .normal)
            $0.titleLabel?.font = .seongiFont(.title_bold_16)
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.primary200, for: .normal)
            $0.titleLabel?.font = .seongiFont(.title_bold_16)
            $0.isHidden = false
        }
        
        startButton.do {
            $0.setTitle("출발하기", for: .normal)
            $0.setTitleColor(.primary200, for: .normal)
            $0.titleLabel?.font = .seongiFont(.title_bold_16)
            $0.isHidden = true
        }
        
        //dot 화면 전환 방지
        pageControl.isUserInteractionEnabled = false
    }
    
    private func setupPageViewController() {
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstPage = pages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    private func bind() {
        let input = OnboardingViewModel.Input(
            skipButtonTapped: skipButton.rx.tap,
            nextButtonTapped: nextButton.rx.tap,
            startButtonTapped: startButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.skipButtonTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.completeOnboarding()
            }).disposed(by: disposeBag)
        
        output.nextButtonTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.currentPageIndex += 1
                owner.pageControl.currentPage = self.currentPageIndex
                owner.pageViewController.setViewControllers(
                    [self.pages[self.currentPageIndex]],
                    direction: .forward,
                    animated: true
                )
                owner.updateButtonTitle()
            }).disposed(by: disposeBag)
        
        output.startButtonTrigger
            .drive(with: self, onNext: { owner, _ in
                owner.completeOnboarding()
            }).disposed(by: disposeBag)
    }
    
    private func updateButtonTitle() {
        let isHidden = currentPageIndex == (pages.count - 1)
        nextButton.isHidden = isHidden
        startButton.isHidden = !isHidden
    }
    
    private func completeOnboarding() {
        // 온보딩 완료 표시
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        // 메인 화면으로 전환
        let mainViewController = HomeViewController(viewModel: HomeViewModel())
        let newRootVC = UINavigationController(rootViewController: mainViewController)
        
        UIView.transition(with: window,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { window.rootViewController = newRootVC },
                          completion: nil)
        window.makeKeyAndVisible()
    }
    
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnboardingPageViewController,
              let index = pages.firstIndex(of: viewController),
              index > 0 else {
            return nil
        }
        
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnboardingPageViewController,
              let index = pages.firstIndex(of: viewController),
              index < pages.count - 1 else {
            return nil
        }
        
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let currentVC = pageViewController.viewControllers?.first as? OnboardingPageViewController,
           let index = pages.firstIndex(of: currentVC) {
            currentPageIndex = index
            pageControl.currentPage = index
            updateButtonTitle()
        }
    }
    
}

final class OnboardingPageViewController: BaseViewController {
    
    private let containerView = UIView()
    private let mainImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    init(image: UIImage?, title: String, description: String) {
        super.init()
        
        setStyle(image: image, title: title, sub: description)
    }
    
    override func setHierarchy() {
        view.addSubview(containerView)
        
        containerView.addSubviews(
            mainImageView,
            titleLabel,
            descriptionLabel
        )
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        mainImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setStyle(image: UIImage?, title: String, sub: String) {
        view.backgroundColor = .bg100
        
        mainImageView.do {
            $0.image = image
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .primary100
        }
        
        titleLabel.setLabelUI(
            title,
            font: .seongiFont(.title_bold_20),
            textColor: .primary300,
            alignment: .center
        )
        
        descriptionLabel.setLabelUI(
            sub,
            font: .seongiFont(.title_bold_16),
            textColor: .primary200,
            alignment: .center,
            numberOfLines: 0
        )
    }
    
}

