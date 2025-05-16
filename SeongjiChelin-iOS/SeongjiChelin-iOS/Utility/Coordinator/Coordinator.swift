//
//  Coordinator.swift
//  SeongjiChelin-iOS
//
//  Created by 박신영 on 5/16/25.
//

import UIKit

// Coordinator 패턴의 기본 프로토콜
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
} 
