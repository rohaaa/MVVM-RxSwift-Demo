//
//  DetailsCoordinator.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 04/05/2023.
//

import UIKit

class DetailsCoordinator: Coordinator {    
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let launch: Launch
    
    init(navigationController: UINavigationController, launch: Launch) {
        self.navigationController = navigationController
        self.launch = launch
    }
    
    func start() {
        let viewModel = DetailsViewModel(launch: launch)
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        detailsViewController.coordinator = self
        navigationController.pushViewController(detailsViewController, animated: true)
    }
    
    func didFinishDetails() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func childDidFinish(_ child: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }
}
