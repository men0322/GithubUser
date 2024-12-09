//
//  UserProfileCoordinator.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import Foundation
import UIKit
import Common

public final class UserProfileCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public weak var parentCoordinator: Coordinator?
    
    public init(navigationController: UINavigationController, parentCoordinator: Coordinator?) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        super.init()
        navigationController.delegate = self
    }
    
    public func start() {
        if let userViewController: UsersViewController = Environment.current.defaultAssembler.resolve() {
            navigationController.pushViewController(userViewController, animated: true)
        }
        
    }
    
    private func showUserDetailScreen() {
        //            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        //            addChildCoordinator(homeCoordinator)
        //            homeCoordinator.start()
    }
    
    // Handle swipe-back and remove child coordinators
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        // Check if the previous view controller was popped
        if let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
           !navigationController.viewControllers.contains(fromViewController) {
            // If the view controller was a LoginViewController, clean up
            //                if fromViewController is LoginViewController {
            //                    parentCoordinator?.removeChildCoordinator(self)
            //                }
        }
    }
}
