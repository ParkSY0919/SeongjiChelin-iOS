//
//  AppCoordinator.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 5/16/25.
//

import UIKit

import SideMenu

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let window: UIWindow
    
    init(navigationController: UINavigationController, window: UIWindow) {
        self.navigationController = navigationController
        self.window = window
    }
    
    func start() {
        // 시작 화면을 먼저 표시
        window.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window.makeKeyAndVisible()
        
        // 앱 업데이트 확인
        checkAppVersionAndContinue()
    }
    
    private func checkAppVersionAndContinue() {
        // 앱 업데이트 확인
        AppUpdateChecker.shared.checkForUpdate { [weak self] needsUpdate in
            guard let self = self else { return }
            
            if !needsUpdate {
                // 업데이트가 필요 없는 경우 기존 로직 실행
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.continueToAppFlow()
                }
            }
        }
    }
    
    private func continueToAppFlow() {
        // 온보딩 표시 여부 확인
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if !hasSeenOnboarding {
            showOnboarding()
        } else {
            showHome()
        }
    }
    
    private func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        addChildCoordinator(onboardingCoordinator)
        onboardingCoordinator.start()
        window.rootViewController = navigationController
    }
    
    private func showHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
        window.rootViewController = navigationController
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCompleted() {
        showHome()
    }
} 
