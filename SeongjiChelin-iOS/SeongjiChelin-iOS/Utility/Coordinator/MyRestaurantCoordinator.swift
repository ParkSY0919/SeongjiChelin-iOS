//
//  MyRestaurantCoordinator.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 5/16/25.
//

import UIKit

final class MyRestaurantCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: MyRestaurantCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let repo = RestaurantRepository()
        let viewModel = MyRestaurantViewModel(repo: repo)
        let myRestaurantVC = MyRestaurantViewController(viewModel: viewModel)
        myRestaurantVC.coordinator = self
        navigationController.pushViewController(myRestaurantVC, animated: true)
    }
    
    func didFinishMyRestaurant() {
        delegate?.didFinish(self)
    }
    
    func showDetail(for restaurant: Restaurant) {
        let detailVM = DetailViewModel(restaurantInfo: restaurant)
        let detailVC = DetailViewController(viewModel: detailVM)
        detailVC.coordinator = self
        navigationController.present(detailVC, animated: true)
    }
}

// MyRestaurantViewControllerDelegate
protocol MyRestaurantViewControllerDelegate: AnyObject {
    func didSelectRestaurant(_ restaurant: Restaurant)
    func didTapBackButton()
} 
