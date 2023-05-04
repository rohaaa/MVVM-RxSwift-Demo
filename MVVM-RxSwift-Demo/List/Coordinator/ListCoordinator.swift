//
//  ListCoordinator.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 04/05/2023.
//

import UIKit

class ListCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ListViewModel(apiService: APIService())
        let listViewController = ListViewController(viewModel: viewModel)
        listViewController.coordinator = self
        navigationController.viewControllers = [listViewController]
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
}

// MARK: - Navigation
extension ListCoordinator {
    func showDetails(for launch: Launch) {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController, launch: launch)
        detailsCoordinator.parentCoordinator = self
        childCoordinators.append(detailsCoordinator)
        detailsCoordinator.start()
    }
}
