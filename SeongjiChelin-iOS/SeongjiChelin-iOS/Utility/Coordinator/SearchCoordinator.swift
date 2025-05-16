//
//  SearchCoordinator.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 5/16/25.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: SearchCoordinatorDelegate?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SearchViewModel()
        let searchVC = SearchViewController(viewModel: viewModel)
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func didFinishSearch() {
        delegate?.didFinish(self)
    }
    
    func showDetail(for restaurant: Restaurant) {
        let detailVM = DetailViewModel(restaurantInfo: restaurant)
        let detailVC = DetailViewController(viewModel: detailVM)
        detailVC.coordinator = self
        navigationController.present(detailVC, animated: true)
    }
}

// SearchViewControllerDelegate
protocol SearchViewControllerDelegate: AnyObject {
    func didSelectRestaurant(_ restaurant: Restaurant)
    func didTapBackButton()
} 
