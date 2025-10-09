//
//  HomeCoordinator.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 5/16/25.
//

import UIKit

import GoogleMaps

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var customSideMenuViewController: SJSideMenuViewController?
    private var isOnboardingActive = false
    
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

        let sideMenuVC = SJSideMenuViewController(contentViewController: menuViewController)
        sideMenuVC.delegate = self
        self.customSideMenuViewController = sideMenuVC

        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            sideMenuVC.attachToViewController(homeVC)
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
        customSideMenuViewController?.show()
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
        navigationController.popToRootViewController(animated: true)
        isOnboardingActive = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.customSideMenuViewController = nil
            self.setupSideMenu()
        }
    }
}

extension HomeCoordinator: MenuViewControllerDelegate {
    func didSelectMenuItem(_ menuItem: String) {
        switch menuItem {
        case StringLiterals.shared.home:
            break
        case StringLiterals.shared.myRestaurants:
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
        removeChildCoordinator(coordinator)

        if navigationController.viewControllers.count > 1 {
            navigationController.popToRootViewController(animated: true)
        }
    }
}

protocol HomeViewControllerDelegate: AnyObject {
    func didTapRestaurant(_ restaurant: Restaurant)
    func didTapSearchTextField()
}

protocol MenuViewControllerDelegate: AnyObject {
    func didSelectMenuItem(_ menuItem: String)
}

protocol SearchCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: Coordinator)
}

protocol MyRestaurantCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: Coordinator)
}

// MARK: - SJSideMenu Delegate

extension HomeCoordinator: SJSideMenuDelegate {
    func sideMenuWillAppear() {
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            homeVC.view.subviews.compactMap { $0 as? GMSMapView }.first?.alpha = 0.6
        }
    }

    func sideMenuDidAppear() {
        // 필요시 추가 구현
    }

    func sideMenuWillDisappear() {
        // 필요시 추가 구현
    }

    func sideMenuDidDisappear() {
        if let homeVC = navigationController.viewControllers.first as? HomeViewController {
            UIView.animate(withDuration: 0.3) {
                homeVC.view.subviews.compactMap { $0 as? GMSMapView }.first?.alpha = 1.0
            }
        }
    }
} 
