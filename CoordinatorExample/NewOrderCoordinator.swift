//
//  NewOrderCoordinator.swift
//  CoordinatorExample
//
//  Created by Will Townsend on 11/11/16.
//  Copyright © 2016 Will Townsend. All rights reserved.
//

import Foundation
import UIKit

protocol NewOrderCoordinatorDelegate: class {

    /// The user tapped the cancel button
    func newOrderCoordinatorDidRequestCancel(newOrderCoordinator: NewOrderCoordinator)

    /// The user completed the order flow with the payload
    func newOrderCoordinator(newOrderCoordinator: NewOrderCoordinator,
                             didAddOrder orderPayload: NewOrderCoordinatorPayload)

}

class NewOrderCoordinatorPayload {
    var selectedDrinkType: String?
    var selectedSnackType: String?
}

class NewOrderCoordinator: RootViewCoordinator {

    // MARK: - Properties

    let services: Services
    var childCoordinators: [Coordinator] = []

    var rootViewController: UIViewController {
        return self.navigationController
    }

    weak var delegate: NewOrderCoordinatorDelegate?

    var orderPayload: NewOrderCoordinatorPayload?

    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    // MARK: - Init

    init(with services: Services) {
        self.services = services
    }

    // MARK: - Functions

    func start() {
        let drinkTypeViewController = DrinkTypeViewController(services: self.services)
        drinkTypeViewController.delegate = self
        self.navigationController.viewControllers = [drinkTypeViewController]
    }

    func showSnackTypeViewController() {
        let snackTypeViewController = SnackTypeViewController(services: self.services)
        snackTypeViewController.delegate = self
        self.navigationController.pushViewController(snackTypeViewController, animated: true)
    }

}

// MARK: - DrinkTypeControllerDelegate

extension NewOrderCoordinator: DrinkTypeControllerDelegate {

    func drinkTypeViewControllerDidTapClose(_ drinkTypeViewController: DrinkTypeViewController) {
        self.delegate?.newOrderCoordinatorDidRequestCancel(newOrderCoordinator: self)
    }

    func drinkTypeViewController(_ drinkTypeViewController: DrinkTypeViewController,
                                 didSelectDrinkType drinkType: String) {

        self.orderPayload = NewOrderCoordinatorPayload()
        self.orderPayload?.selectedDrinkType = drinkType

        self.showSnackTypeViewController()
    }

}

// MARK: - SnackTypeViewControllerDelegate

extension NewOrderCoordinator: SnackTypeViewControllerDelegate {

    func snackTypeViewController(_ snackTypeViewController: SnackTypeViewController,
                                 didSelectSnackType snackType: String) {

        self.orderPayload?.selectedSnackType = snackType

        if let newOrderPayload = self.orderPayload {
            self.delegate?.newOrderCoordinator(newOrderCoordinator: self, didAddOrder: newOrderPayload)
        }
    }
}
