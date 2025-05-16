//
//  OnboardingCoordinator.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 5/16/25.
//

import UIKit

// 온보딩 완료 시 AppCoordinator에 알리기 위한 delegate 프로토콜
protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingCompleted()
}

final class OnboardingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: OnboardingCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.delegate = self
        navigationController.setViewControllers([onboardingVC], animated: true)
    }
}

extension OnboardingCoordinator: OnboardingViewControllerDelegate {
    func onboardingDidComplete() {
        // 온보딩 완료 시 UserDefaults에 상태 저장
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        // 상위 코디네이터에 완료 알림
        delegate?.onboardingCompleted()
    }
}

// OnboardingViewControllerDelegate
protocol OnboardingViewControllerDelegate: AnyObject {
    func onboardingDidComplete()
} 
