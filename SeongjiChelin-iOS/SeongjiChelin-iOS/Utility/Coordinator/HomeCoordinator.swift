//
//  HomeCoordinator.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 5/16/25.
//

import UIKit

import SideMenu

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var menuNavigationController: SideMenuNavigationController?
    private var isOnboardingActive = false // 온보딩 상태 추적
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel()
        let homeVC = HomeViewController(viewModel: viewModel)
        homeVC.coordinator = self
        navigationController.setViewControllers([homeVC], animated: true)
        setupSideMenu()
    }
    
    private func setupSideMenu() {
        let menuViewController = MenuViewController(viewModel: MenuViewModel())
        menuViewController.delegate = self
        
        let menuNavigationController = SideMenuNavigationController(rootViewController: menuViewController)
        self.menuNavigationController = menuNavigationController
        
        menuNavigationController.leftSide = true
        menuNavigationController.presentationStyle = .menuSlideIn
        menuNavigationController.pushStyle = .default
        menuNavigationController.presentDuration = 0.5
        menuNavigationController.dismissDuration = 0.35
        
        // 시스템 전역 설정
        SideMenuManager.default.leftMenuNavigationController = menuNavigationController
        SideMenuManager.default.rightMenuNavigationController = nil // 오른쪽 메뉴 비활성화
        
        // 홈 화면에 제스처 추가
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: homeVC.view, forMenu: .left)
        }
    }
    
    func showSideMenu() {
        if isOnboardingActive {
            return
        }
        
        // 현재 표시된 DetailViewController가 있으면 먼저 닫음
        if let presentedVC = navigationController.presentedViewController {
            presentedVC.dismiss(animated: true) { [weak self] in
                self?.presentSideMenu()
            }
        } else {
            presentSideMenu()
        }
    }
    
    private func presentSideMenu() {
        // 기존 메뉴 인스턴스가 없거나 문제가 있으면 다시 설정
        if menuNavigationController == nil {
            setupSideMenu()
        }
        
        // SideMenu 방향 재확인
        menuNavigationController?.leftSide = true
        
        guard let menuNav = menuNavigationController else { return }
        navigationController.present(menuNav, animated: true)
    }
    
    func showDetail(for restaurant: Restaurant) {
        let detailVM = DetailViewModel(restaurantInfo: restaurant)
        let detailVC = DetailViewController(viewModel: detailVM)
        detailVC.coordinator = self
        navigationController.present(detailVC, animated: true)
    }
    
    func showSearch() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        addChildCoordinator(searchCoordinator)
        searchCoordinator.delegate = self
        searchCoordinator.start()
    }
    
    func showMyRestaurant() {
        let myRestaurantCoordinator = MyRestaurantCoordinator(navigationController: navigationController)
        addChildCoordinator(myRestaurantCoordinator)
        myRestaurantCoordinator.delegate = self
        myRestaurantCoordinator.start()
    }
    
    func showOnboarding() {
        // 이미 온보딩이 활성화되어 있으면 중복 실행 방지
        if isOnboardingActive || navigationController.topViewController is OnboardingViewController {
            return
        }
        
        isOnboardingActive = true
        
        let onboardingVC = OnboardingViewController()
        onboardingVC.delegate = self // OnboardingViewController에 delegate 추가
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    func showInfoReport() {
        let webVC = SJWebViewController(urlString: "https://notch-crate-349.notion.site/1d46931aa0158095b055d762d55f5d2a?pvs=4")
        navigationController.present(webVC, animated: true)
    }
}

// 온보딩 완료 처리를 위한 Delegate 구현
extension HomeCoordinator: OnboardingViewControllerDelegate {
    func onboardingDidComplete() {
        // 온보딩이 완료되면 홈 화면으로 돌아감
        navigationController.popToRootViewController(animated: true)
        isOnboardingActive = false
        
        // SideMenu 완전히 재설정 - 온보딩 이후 SideMenu 문제 해결
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.menuNavigationController = nil
            self.setupSideMenu()
            
            // HomeViewController의 제스처 재설정
            if let homeVC = self.navigationController.viewControllers.first as? HomeViewController {
                SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: homeVC.view, forMenu: .left)
            }
        }
    }
}

extension HomeCoordinator: MenuViewControllerDelegate {
    func didSelectMenuItem(_ menuItem: String) {
        // 메뉴 선택 시 한 번만 처리되도록 함
        switch menuItem {
        case StringLiterals.shared.home:
            // 현재 화면이 이미 홈이므로 아무것도 하지 않음
            break
        case StringLiterals.shared.myRestaurants:
            // 메뉴에서 화면 전환 시 중복 방지를 위해 childCoordinators 확인
            if !childCoordinators.contains(where: { $0 is MyRestaurantCoordinator }) {
                showMyRestaurant()
            }
        case StringLiterals.shared.howToUse:
            showOnboarding()
        case StringLiterals.shared.reportCorrection:
            showInfoReport()
        default:
            break
        }
    }
}

extension HomeCoordinator: SearchCoordinatorDelegate, MyRestaurantCoordinatorDelegate {
    func didFinish(_ coordinator: Coordinator) {
        // Child coordinator가 완료되면 제거
        removeChildCoordinator(coordinator)
        
        // 다시 홈으로 돌아옴 (만약 필요하다면)
        if navigationController.viewControllers.count > 1 {
            navigationController.popToRootViewController(animated: true)
        }
    }
}

// 홈 뷰컨트롤러 델리게이트 프로토콜
protocol HomeViewControllerDelegate: AnyObject {
    func didTapRestaurant(_ restaurant: Restaurant)
    func didTapSearchTextField()
}

// 메뉴 뷰컨트롤러 델리게이트 프로토콜
protocol MenuViewControllerDelegate: AnyObject {
    func didSelectMenuItem(_ menuItem: String)
}

// SearchCoordinator 및 MyRestaurantCoordinator 프로토콜
protocol SearchCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: Coordinator)
}

protocol MyRestaurantCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: Coordinator)
} 
