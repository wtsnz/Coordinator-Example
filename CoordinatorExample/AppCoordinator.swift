//
//  AppCoordinator.swift
//  CoordinatorExample
//
//  Created by Will Townsend on 11/11/16.
//  Copyright © 2016 Will Townsend. All rights reserved.
//

import Foundation
import UIKit

/// The AppCoordinator is our first coordinator
/// In this example the AppCoordinator as a rootViewController
class AppCoordinator: RootViewCoordinator {
    
    // MARK: - Properties
    
    let services: Services
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    /// Window to manage
    let window: UIWindow
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    // MARK: - Init
    
    public init(window: UIWindow, services: Services) {
        self.services = services
        self.window = window
        
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Functions
    
    /// Starts the coordinator
    public func start() {
        self.showSplashViewController()
    }
    
    /// Creates a new SplashViewController and places it into the navigation controller
    private func showSplashViewController() {
        let splashViewController = SplashViewController(services: self.services)
        splashViewController.delegate = self
        self.navigationController.viewControllers = [splashViewController]
    }
    
}

// MARK: - SplashViewControllerDelegate

extension AppCoordinator: SplashViewControllerDelegate {
    
    func splashViewControllerDidTapNewOrder(splashViewController: SplashViewController) {
        
        let newOrderCoordinator = NewOrderCoordinator(with: self.services)
        newOrderCoordinator.delegate = self
        newOrderCoordinator.rootViewController.modalPresentationStyle = .fullScreen
        newOrderCoordinator.start()
        self.addChildCoordinator(newOrderCoordinator)
        self.rootViewController.present(newOrderCoordinator.rootViewController, animated: true, completion: nil)
    }
    
}

// MARK: - NewOrderCoordinatorDelegate

extension AppCoordinator: NewOrderCoordinatorDelegate {
    
    func newOrderCoordinatorDidRequestCancel(newOrderCoordinator: NewOrderCoordinator) {
        
        newOrderCoordinator.rootViewController.dismiss(animated: true)
        self.removeChildCoordinator(newOrderCoordinator)
        
    }
    
    func newOrderCoordinator(newOrderCoordinator: NewOrderCoordinator, didAddOrder orderPayload: NewOrderCoordinatorPayload) {
        
        guard let drinkType = orderPayload.selectedDrinkType,
            let snackType = orderPayload.selectedSnackType else {
                return
        }
        
        let order = Order(drinkType: drinkType, snackType: snackType)
        
        self.services.dataService.orders.append(order)
        
        newOrderCoordinator.rootViewController.dismiss(animated: true)
        self.removeChildCoordinator(newOrderCoordinator)
    }
}
